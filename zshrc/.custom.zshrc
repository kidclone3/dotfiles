export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# ===================================================================
# ALIASES CONFIGURATION
# ===================================================================

# Directory Navigation Aliases
alias cdc=~/Documents/code

# Development Tools Aliases  
alias pc=pycharm

# Python Development Aliases
alias mkpydir='function _mkpydir() { mkdir -p "$1" && touch "$1/__init__.py"; }; _mkpydir'

alias ccm='npx @anthropic-ai/claude-code --dangerously-skip-permissions "$@"'

