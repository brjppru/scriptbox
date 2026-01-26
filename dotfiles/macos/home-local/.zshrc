#!/usr/bin/env zsh
#
# brj@.zshrc
#

# 2024.04.25 Woman That Rolls
# 2024.06.22 Fix autoupdate, a to zaebalo
# 2024.12.19 Optimized
# 2025.10.17 full rewrite add kitty integration
# 2025.10.24 battary plugin -> fix shell
# 2026.01.25 cleanup completion init, path priority, remove global GAC
# 2026.01.26 session: plugins, history, colors, mc aliases, kitty cursor fix

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

# Set locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Stable ls/completion colors
export CLICOLOR=1
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# Prefer user and Homebrew bins before system
export PATH="$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
# Deduplicate PATH entries
typeset -U path PATH

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
export ZSH_CACHE_DIR="$ZSH/cache"
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
export ZSH_DISABLE_COMPFIX=false

# Add custom functions before compinit (Oh My Zsh runs compinit)
fpath+=("$HOME/.zfunc")

# Ensure cache dir exists
[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"

# Oh My Zsh optional variables
export CASE_SENSITIVE="true"
export ENABLE_CORRECTION="false"
export DISABLE_MAGIC_FUNCTIONS="true"
export DISABLE_LS_COLORS="false"
export UPDATE_ZSH_DAYS=13

# Auto-update settings
export DISABLE_AUTO_UPDATE="false"
export DISABLE_UPDATE_PROMPT="true"
export DISABLE_UNTRACKED_FILES_DIRTY="true"

# =============================================================================
# OH MY ZSH CONFIGURATION
# =============================================================================

# Check if Oh My Zsh exists
if [[ -d "$ZSH" ]]; then
    # Plugins (removed duplicates and optimized)
    plugins=(
        battery
        autoupdate
        bgnotify
        fast-syntax-highlighting
        colored-man-pages
        ansible
        brew
        macos
        sudo
        tmux
        colorize
        command-not-found
        kitty
        ssh
        zsh-interactive-cd
        zsh-autosuggestions
    )
    
    # Plugin configurations
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    bgnotify_threshold=30
    
    # SSH agent configuration
    zstyle :omz:plugins:ssh-agent agent-forwarding no
    zstyle :omz:plugins:ssh-agent identities id_oss
    
    # Auto-update configuration (handled by environment variables above)
    zstyle ':omz:update' mode auto

    # Theme & prompt settings
    ZSH_THEME="jonathan"

    # Load Oh My Zsh
    source "$ZSH/oh-my-zsh.sh"

    # Battery prompt settings (requires battery plugin)
    BATTERY_CHARGING="⚡️"
    BATTERY_SHOW_WATTS=true
    RPROMPT='$(battery_pct_prompt) '"$RPROMPT"
else
    echo "Warning: Oh My Zsh not found at $ZSH"
fi

# =============================================================================
# COMPLETION SYSTEM
# =============================================================================

# Completion settings (compinit is handled by Oh My Zsh)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# Set completion colors if LS_COLORS is available
if [[ -n "$LS_COLORS" ]]; then
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# =============================================================================
# ALIASES AND FUNCTIONS
# =============================================================================

# mc hack - Midnight Commander with proper terminal support
alias mc="/opt/homebrew/bin/mc --nosubshell"
alias mcold="SHELL=/bin/bash TERM=xterm-256color /opt/homebrew/bin/mc --nosubshell"

# =============================================================================
# ADDITIONAL OPTIMIZATIONS
# =============================================================================

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Directory navigation
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Globbing
setopt EXTENDED_GLOB
setopt GLOB_COMPLETE

# Other useful options
setopt AUTO_CD
setopt CORRECT
setopt NO_BEEP

# =============================================================================

# Quick directory listing
function ll() {
    ls -alF "$@"
}

# =============================================================================
if [[ -n "$KITTY_INSTALLATION_DIR" ]]; then
  export KITTY_SHELL_INTEGRATION="enabled no-cursor"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi
# =============================================================================

# =============================================================================
# The end
