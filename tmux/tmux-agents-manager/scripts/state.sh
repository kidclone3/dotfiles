#!/usr/bin/env bash
# Record an agent pane's state as a per-pane user option.
# Wire this into an agent's hooks/events: state.sh <working|waiting|idle>
# Outside tmux this is intentionally a no-op.
[ -z "${TMUX_PANE:-}" ] && exit 0

case "${1:-idle}" in
  working|waiting) state="$1";;
  *) state="idle";;
esac

tmux set-option -p -t "$TMUX_PANE" @agent_state "$state"
exit 0
