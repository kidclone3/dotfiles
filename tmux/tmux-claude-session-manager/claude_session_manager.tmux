#!/usr/bin/env bash
# tmux-claude-session-manager
#
# Pick Claude Code panes in the current tmux session from a popup picker.
# tpm runs this file as an executable on tmux startup; it reads user options
# (with sensible defaults) and installs the key bindings.

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/helpers.sh
. "$CURRENT_DIR/scripts/helpers.sh"

list_key="$(get_tmux_option @claude_list_key 'a')"

# Open the pane picker.
tmux bind-key "$list_key" \
  run-shell "$CURRENT_DIR/scripts/list.sh '#{client_name}'"
