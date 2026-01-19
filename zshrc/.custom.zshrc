export ZSH_CUSTOM=/home/delus/Documents/tools/dotfiles/oh-my-zsh/.oh-my-zsh/custom

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
# AUTO-ACTIVATE CONDA ENV BY FOLDER NAME
# ===================================================================

# Auto-activate conda environment if it matches current folder name
function auto_conda_activate() {
    local folder_name=$(basename "$PWD")

    # Check if conda env exists with this name
    if conda env list | grep -qw "^$folder_name "; then
        # Only activate if not already in this env
        if [[ "$CONDA_DEFAULT_ENV" != "$folder_name" ]]; then
            conda activate "$folder_name"
        fi
    else
        echo "⚠️   No conda env found for: $folder_name"
    fi
}

# Run on shell startup (works for new tmux panes/windows)
auto_conda_activate