#!/usr/bin/env bash
# Shared helpers for tmux-claude-session-manager.

# get_tmux_option <option-name> <default>
# Echoes the global tmux option value, or the default when unset/empty.
get_tmux_option() {
  local value
  value="$(tmux show-option -gqv "$1" 2>/dev/null)"
  if [ -n "$value" ]; then
    printf '%s' "$value"
  else
    printf '%s' "$2"
  fi
}

# get_tmux_option_fallback <primary> <legacy> <default>
# Reads the generic option first, then an optional legacy migration name.
get_tmux_option_fallback() {
  local value
  value="$(get_tmux_option "$1" '')"
  [ -n "$value" ] || value="$(get_tmux_option "$2" "$3")"
  printf '%s' "$value"
}
