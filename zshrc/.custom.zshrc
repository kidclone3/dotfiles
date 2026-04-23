export ZSH_CUSTOM=$HOME/Documents/tools/dotfiles/oh-my-zsh/.oh-my-zsh/custom

# ===================================================================
# ALIASES CONFIGURATION
# ===================================================================

# Directory Navigation Aliases
alias cdc=~/Documents/code

# Development Tools Aliases  
alias pc=pycharm

# Python Development Aliases
alias mkpydir='function _mkpydir() { mkdir -p "$1" && touch "$1/__init__.py"; }; _mkpydir'


# ===================================================================
# UV ENVIRONMENT MANAGEMENT
# ===================================================================

export UV_ENV_DIR="$HOME/.local/share/uv/envs"

# uva - activate a named uv environment
uva() { source "$UV_ENV_DIR/$1/bin/activate"; }

# uvc - create a named uv environment
uvc() { uv venv "$UV_ENV_DIR/$1" --python "${2:-3.12}"; }

# Auto-activate uv environment if it matches current folder name
function auto_uv_activate() {
    local folder_name=$(basename "$PWD")

    # Check if uv env exists with this name
    if [[ -d "$UV_ENV_DIR/$folder_name" ]]; then
        # Only activate if not already in this env
        if [[ "$VIRTUAL_ENV" != "$UV_ENV_DIR/$folder_name" ]]; then
            source "$UV_ENV_DIR/$folder_name/bin/activate"
        fi
    fi
}

# Run on shell startup (works for new tmux panes/windows)
auto_uv_activate