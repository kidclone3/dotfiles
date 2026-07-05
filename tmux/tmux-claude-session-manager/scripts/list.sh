#!/usr/bin/env bash
# Open the pane picker in a popup.
# Arg: client_name (so the picker can switch the correct client on jump).
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=helpers.sh
. "$DIR/helpers.sh"

client="${1:-}"
w="$(get_tmux_option @claude_popup_width '90%')"
h="$(get_tmux_option @claude_popup_height '90%')"

if [ -n "${TMUX_POPUP:-}" ]; then
  exec "$DIR/picker.sh" "$client"
else
  tmux display-popup -w "$w" -h "$h" -E "$DIR/picker.sh $client"
fi
