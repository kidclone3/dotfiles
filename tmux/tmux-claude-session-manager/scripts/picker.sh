#!/usr/bin/env bash
# Interactive picker for Claude Code panes in the current tmux session.
# Lists every pane whose current command is `claude`, previews its screen,
# and on enter focuses it via the caller's client.
# Arg: client_name (from the tmux binding, so we switch the right client).
#      --list  → output rows and exit (used by fzf's ctrl-x reload).
set -uo pipefail

# pane_id <TAB> status <TAB> window.index <TAB> title <TAB> path
rows() {
  tmux list-panes -s -f '#{==:#{pane_current_command},claude}' \
    -F '#{pane_id}	#{@claude_state}	#{window_index}.#{pane_index}	#{pane_title}	#{pane_current_path/#$HOME/~}' \
    2>/dev/null | while IFS='	' read -r pane_id state win title path; do
      case "$state" in
        working) icon="🟡";;
        waiting) icon="🟢";;
        *)       icon="⚪"; state="idle";;
      esac
      printf '%s\t%s %s\t%s\t%s\t%s\n' "$pane_id" "$icon" "$state" "$win" "$title" "$path"
    done
}

# --list mode: just dump rows so fzf can reload after a kill.
if [ "${1:-}" = "--list" ]; then
  rows
  exit 0
fi

client="${1:-}"

command -v fzf >/dev/null 2>&1 || {
  tmux display-message "tmux-claude-session-manager: fzf is required"
  exit 0
}

sel=$(rows | fzf --ansi --delimiter='\t' --with-nth=2,3,4,5 \
  --reverse --cycle --header='Claude panes · enter: jump  ctrl-x: kill' \
  --preview='tmux capture-pane -ept {1}' --preview-window='right,62%,wrap' \
  --bind "ctrl-x:execute(tmux kill-pane -t {1})+reload($0 --list)")

[ -z "$sel" ] && exit 0

pane=$(printf '%s' "$sel" | cut -f1)
if [ -n "$client" ]; then
  tmux switch-client -c "$client" -t "$pane"
else
  tmux select-pane -t "$pane"
fi
