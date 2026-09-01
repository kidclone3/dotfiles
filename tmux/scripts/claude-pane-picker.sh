#!/usr/bin/env bash
# Picker for Claude Code panes running anywhere in tmux — including ones started
# outside the tmux-agents-manager plugin. Lists every pane whose current
# command is `claude`, previews its screen, and on enter jumps the invoking
# client to that pane.
#
# Bound in .tmux.conf via:  display-popup -E "<this> '#{client_name}'"
# The client name is the OUTER client that pressed the key, so we switch it
# rather than the transient popup client.
set -uo pipefail

client="${1:-}"

command -v fzf >/dev/null 2>&1 || {
  tmux display-message "claude-pane-picker: fzf is required"
  exit 0
}

# pane_id <TAB> session:window.pane <TAB> title <TAB> path  (pane_id hidden in fzf)
rows() {
  tmux list-panes -a -f '#{==:#{pane_current_command},claude}' \
    -F '#{pane_id}	#{session_name}:#{window_index}.#{pane_index}	#{pane_title}	#{pane_current_path/#$HOME/~}' \
    2>/dev/null
}

sel=$(rows | fzf --ansi --delimiter='\t' --with-nth=2,3,4 \
  --reverse --cycle --header='Claude panes · enter: jump' \
  --preview='tmux capture-pane -ept {1}' --preview-window='right,62%,wrap')

[ -z "$sel" ] && exit 0

pane=$(printf '%s' "$sel" | cut -f1)
win=$(tmux display-message -p -t "$pane" '#{session_name}:#{window_index}') || exit 0

if [ -n "$client" ]; then
  tmux switch-client -c "$client" -t "$win"
else
  tmux switch-client -t "$win"
fi
tmux select-pane -t "$pane"
