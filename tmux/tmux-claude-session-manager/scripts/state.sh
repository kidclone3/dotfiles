#!/usr/bin/env bash
# Record a Claude Code pane's state as a per-pane user option.
# Wire this into Claude Code hooks:  state.sh <working|waiting|idle>
#
# Claude Code hooks inherit the Claude process environment, so $TMUX_PANE is set
# whenever Claude runs inside tmux. Outside tmux this is a no-op.
[ -z "${TMUX_PANE:-}" ] && exit 0

state="${1:-idle}"
tmux set-option -p -t "$TMUX_PANE" @claude_state "$state"
exit 0
