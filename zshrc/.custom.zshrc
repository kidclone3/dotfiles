# ===================================================================
# ALIASES CONFIGURATION
# ===================================================================

# Directory Navigation Aliases
alias cdc=~/Documents/code


# Python Development Aliases
alias mkpydir='function _mkpydir() { mkdir -p "$1" && touch "$1/__init__.py"; }; _mkpydir'


# ASDF configuration
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
fpath=(${ASDF_DATA_DIR}/completions $fpath)
autoload -Uz compinit && compinit

# FZF configuration
export FZF_BASE=/opt/homebrew/opt/fzf
