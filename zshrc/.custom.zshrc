export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# ===================================================================
# ALIASES CONFIGURATION
# ===================================================================

# Directory Navigation Aliases
alias cdc=~/Documents/code

# Python Development Aliases
alias mkpydir='function _mkpydir() { mkdir -p "$1" && touch "$1/__init__.py"; }; _mkpydir'

# ccm - Claude Code with credentials from ~/.claude/.env
function ccm() {
    (
        set -a
        source ~/.claude/.env
        set +a
        claude --dangerously-skip-permissions "$@"
    )
}

# systemd --user bus address (terminal emulator skips pam_systemd)
[ -z "$XDG_RUNTIME_DIR" ] && export XDG_RUNTIME_DIR=/run/user/$UID
[ -z "$DBUS_SESSION_BUS_ADDRESS" ] && export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"

