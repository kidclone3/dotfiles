# revalidate again, i have remove the duplicated:
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See [https://github.com/ohmyzsh/ohmyzsh/wiki/Themes](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
# ZSH_THEME="robbyrussell"


ZSH_THEME="powerlevel10k/powerlevel10k"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )


# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"


# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"


# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto  # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time


# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13


# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"


# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"


# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"


# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"


# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"


# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"


# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"


# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git 
	zsh-syntax-highlighting
	zsh-autosuggestions
	fzf
)


# FZF configuration
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'


source $ZSH/oh-my-zsh.sh


# User configuration


# export MANPATH="/usr/local/man:$MANPATH"


# You may need to manually set your language environment
# export LANG=en_US.UTF-8


# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#     export EDITOR='vim'
# else
#     export EDITOR='mvim'
# fi


# Compilation flags
# export ARCHFLAGS="-arch x86_64"


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# itsmeit - config Vietnamese (Unikey)
# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus



# ===================================================================
# CUSTOM FUNCTIONS AND FUNCTION ALIASES
# ===================================================================


# Warp VPN Toggle Function and Alias
RED='\033[0;31m'
function warp_func() {
if warp-cli status | grep -q "Disconnected";
then
warp-cli connect
echo "${RED}Warp connected"
else
warp-cli disconnect
echo "${RED}Warp disconnected"
fi
}
alias warp='warp_func'

export PATH="$HOME/.local/bin:$PATH"

PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;


typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet


# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
# append completions to fpath
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# Check battery adapter


# alias bcheck="acpi -a"
# alias kubed="kubectl -n dev"

# Load custom zsh configuration
. ~/.custom.zshrc


# ccg - Claude Code with GLM config (credentials scoped to this command only)
function ccg() {
    (
        set -a
        source ~/.claude-glm/.env
        set +a
        CLAUDE_CONFIG_DIR=~/.claude-glm claude --dangerously-skip-permissions "$@"
    )
}
alias ccm="claude --dangerously-skip-permissions"
alias ccu='CLAUDE_CONFIG_DIR="$HOME/.claude,$HOME/.claude-max" npx ccusage@latest'


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias claude-mem='$HOME/.bun/bin/bun "$HOME/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'
# Claude Code: Handle duplicate rules between project and global
# Usage: cc-fix-dupes [project_dir]
# Defaults to current directory if no argument provided
cc-fix-dupes() {
    local project_dir="${1:-.}"
    local global_rules="$HOME/.claude/rules"
    local local_rules="$project_dir/.claude/rules"

    # Check if directories exist
    if [[ ! -d "$local_rules" ]]; then
        echo "⚠️  No .claude/rules found in $project_dir"
        return 1
    fi

    if [[ ! -d "$global_rules" ]]; then
        echo "⚠️  No global rules found at $global_rules"
        return 1
    fi

    echo "🔍 Checking for duplicate rules..."
    echo "   Global: $global_rules"
    echo "   Local:  $local_rules"
    echo ""

    local found_dupes=false
    local renamed_count=0

    # Find duplicates and rename global ones
    for local_file in "$local_rules"/*.md; do
        [[ -f "$local_file" ]] || continue

        local filename=$(basename "$local_file")
        local global_file="$global_rules/$filename"

        if [[ -f "$global_file" ]]; then
            if [[ ! -f "$global_file.bak" ]]; then
                echo "📝 Renaming: $filename"
                mv "$global_file" "$global_file.bak"
                ((renamed_count++))
            else
                echo "⏭️  Already backed up: $filename"
            fi
            found_dupes=true
        fi
    done

    echo ""
    if [[ "$found_dupes" == "true" ]]; then
        echo "✅ Done! Renamed $renamed_count file(s)"
        echo "💡 To restore: mv ~/.claude/rules/*.bak ~/.claude/rules/"
    else
        echo "✨ No duplicates found!"
    fi
}

# Quick alias

export TERM=xterm-256color

alias glm-claude="nix develop ~/nix-shells/glm-claude"
