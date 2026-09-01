#!/usr/bin/env bash
# Interactive picker for supported agent panes in the current tmux session.
# Arg: client_name (from the tmux binding, so we switch the right client).
#      --list  -> output rows and exit (used by fzf's ctrl-x reload).
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=helpers.sh
. "$DIR/helpers.sh"

identities=(claude codex pi oh-my-pi hermes feynman)
declare -A commands icons default_commands
default_commands[claude]='claude'
default_commands[codex]='codex'
default_commands[pi]='pi'
default_commands[oh-my-pi]='oh-my-pi|omp'
default_commands[hermes]='hermes'
default_commands[feynman]='feynman|feynman.js'
icons[claude]='◈'
icons[codex]='◉'
icons[pi]='π'
icons[oh-my-pi]='✦'
icons[hermes]='♞'
icons[feynman]='ƒ'

valid_identity() {
  case "$1" in
    claude|codex|pi|oh-my-pi|hermes|feynman) return 0;;
    *) return 1;;
  esac
}

append_command() {
  local identity="$1" command="$2"
  [ -n "$command" ] || return 0
  case "|${commands[$identity]}|" in
    *"|$command|"*) return 0;;
  esac
  if [ -n "${commands[$identity]}" ]; then
    commands[$identity]="${commands[$identity]}|$command"
  else
    commands[$identity]="$command"
  fi
}

parse_commands() {
  local raw token identity command
  raw="$(get_tmux_option @agent_commands '')"
  for identity in "${identities[@]}"; do commands[$identity]="${default_commands[$identity]}"; done
  IFS=',' read -ra tokens <<< "$raw"
  for token in "${tokens[@]}"; do
    token="${token//[[:space:]]/}"
    [ -n "$token" ] || continue
    [[ "$token" == *=* ]] || continue
    identity="${token%%=*}"
    command="${token#*=}"
    valid_identity "$identity" || continue
    commands[$identity]=''
    IFS='|' read -ra aliases <<< "$command"
    for command in "${aliases[@]}"; do append_command "$identity" "$command"; done
  done
}

parse_icons() {
  local raw token identity icon
  raw="$(get_tmux_option @agent_icons '')"
  [ -n "$raw" ] || return 0
  IFS=',' read -ra tokens <<< "$raw"
  for token in "${tokens[@]}"; do
    identity="${token%%=*}"
    icon="${token#*=}"
    valid_identity "$identity" && [ "$token" != "$identity" ] && icons[$identity]="$icon"
  done
}

identity_for_token() {
  local token="$1" identity alias
  token="${token##*/}"
  for identity in "${identities[@]}"; do
    IFS='|' read -ra aliases <<< "${commands[$identity]}"
    for alias in "${aliases[@]}"; do
      [ "$token" = "$alias" ] && { printf '%s' "$identity"; return 0; }
    done
  done
  return 1
}

identity_for_argv() {
  local args="$1" launcher token identity i
  local -a argv=()
  read -r -a argv <<< "$args"
  [ "${#argv[@]}" -gt 0 ] || return 1

  if identity="$(identity_for_token "${argv[0]}")"; then
    printf '%s' "$identity"
    return 0
  fi

  launcher="${argv[0]##*/}"
  case "$launcher" in
    env)
      for ((i = 1; i < ${#argv[@]}; i++)); do
        token="${argv[$i]}"
        case "$token" in
          -u|--unset|-C|--chdir|--split-string) i=$((i + 1)); continue;;
          --|-*|*=*) continue;;
        esac
        identity_for_token "$token"
        return
      done
      ;;
    node|nodejs)
      for ((i = 1; i < ${#argv[@]}; i++)); do
        token="${argv[$i]}"
        case "$token" in
          -e*|--eval|--eval=*|-p*|--print|--print=*) return 1;;
          -r|--require|--import|--loader|--experimental-loader) i=$((i + 1)); continue;;
          --require=*|--import=*|--loader=*|--experimental-loader=*|-*) continue;;
          --) continue;;
        esac
        identity_for_token "$token"
        return
      done
      ;;
    bun|bunx)
      for ((i = 1; i < ${#argv[@]}; i++)); do
        token="${argv[$i]}"
        case "$token" in
          -e*|--eval|--eval=*|-p*|--print|--print=*) return 1;;
          -r|--preload|--cwd) i=$((i + 1)); continue;;
          --preload=*|--cwd=*|-*) continue;;
          --|run) continue;;
        esac
        identity_for_token "$token"
        return
      done
      ;;
  esac
  return 1
}

identity_for_args() {
  local root_pid="$1" foreground_pgid entry pid depth child child_pgid args identity
  local -a queue=()

  args="$(ps -o args= -p "$root_pid" 2>/dev/null || true)"
  if identity="$(identity_for_argv "$args")"; then
    printf '%s' "$identity"
    return 0
  fi

  foreground_pgid="$(ps -o tpgid= -p "$root_pid" 2>/dev/null || true)"
  foreground_pgid="${foreground_pgid//[[:space:]]/}"
  case "$foreground_pgid" in
    ''|-1|0) return 1;;
  esac

  while read -r child; do
    [ -n "$child" ] || continue
    child_pgid="$(ps -o pgid= -p "$child" 2>/dev/null || true)"
    child_pgid="${child_pgid//[[:space:]]/}"
    [ "$child_pgid" = "$foreground_pgid" ] && queue+=("$child:1")
  done < <(pgrep -P "$root_pid" 2>/dev/null || true)

  while [ "${#queue[@]}" -gt 0 ]; do
    entry="${queue[0]}"
    queue=("${queue[@]:1}")
    pid="${entry%%:*}"
    depth="${entry#*:}"

    args="$(ps -o args= -p "$pid" 2>/dev/null || true)"
    if identity="$(identity_for_argv "$args")"; then
      printf '%s' "$identity"
      return 0
    fi
    [ "$depth" -lt 5 ] || continue

    while read -r child; do
      [ -n "$child" ] || continue
      child_pgid="$(ps -o pgid= -p "$child" 2>/dev/null || true)"
      child_pgid="${child_pgid//[[:space:]]/}"
      [ "$child_pgid" = "$foreground_pgid" ] && queue+=("$child:$((depth + 1))")
    done < <(pgrep -P "$pid" 2>/dev/null || true)
  done
  return 1
}

identity_for_command() {
  identity_for_token "$1"
}

# pane_id <TAB> state <TAB> agent icon <TAB> window.index <TAB> title <TAB> path
rows() {
  local pane_id current_command pane_pid state win title path identity state_icon target
  parse_commands
  parse_icons
  target="$(tmux display-message -p '#S' 2>/dev/null || true)"
  [ -n "$target" ] || target="${TMUX_PANE:-}"
  [ -n "$target" ] || return 0
  tmux list-panes -s -t "$target" \
    -F '#{pane_id}|#{pane_current_command}|#{pane_pid}|#{@agent_state}|#{window_index}.#{pane_index}|#{pane_title}|#{pane_current_path/#$HOME/~}' \
    2>/dev/null | while IFS='|' read -r pane_id current_command pane_pid state win title path; do
      identity="$(identity_for_command "$current_command" 2>/dev/null || true)"
      [ -n "$identity" ] || identity="$(identity_for_args "$pane_pid" 2>/dev/null || true)"
      [ -n "$identity" ] || continue
      case "$state" in
        working) state_icon="🟡";;
        waiting) state_icon="🟢";;
        *) state_icon="⚪"; state="idle";;
      esac
      printf '%s\t%s %s\t%s\t%s\t%s\t%s\n' "$pane_id" "$state_icon" "$state" "${icons[$identity]}" "$win" "$title" "$path"
    done
}

if [ "${1:-}" = "--list" ]; then
  rows
  exit 0
fi

client="${1:-}"
command -v fzf >/dev/null 2>&1 || {
  tmux display-message 'tmux-agents-manager: fzf is required'
  exit 0
}

sel="$(rows | fzf --ansi --delimiter='\t' --with-nth=2,3,4,5,6 \
  --reverse --cycle --header='Agent panes · enter: jump  ctrl-x: kill' \
  --preview='tmux capture-pane -ept {1}' --preview-window='right,62%,wrap' \
  --bind "ctrl-x:execute(tmux kill-pane -t {1})+reload($0 --list)")"

[ -n "$sel" ] || exit 0
pane="$(printf '%s' "$sel" | cut -f1)"
if [ -n "$client" ]; then
  tmux switch-client -c "$client" -t "$pane"
else
  tmux select-pane -t "$pane"
fi
