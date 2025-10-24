#!/usr/bin/env zsh
#
# brj@.zshrc
#

# 2024.04.25 Woman That Rolls
# 2024.06.22 Fix autoupdate, a to zaebalo
# 2024.12.19 Optimized
# 2025.10.17 full rewrite add kitty integration
# 2025.10.24 battary plugin -> fix shell

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

# Set locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Safe PATH modification (append instead of prepend)
export PATH="$PATH:$HOME/bin:/usr/local/bin"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
export ZSH_CACHE_DIR="$ZSH/cache"
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
export ZSH_DISABLE_COMPFIX=true

# Oh My Zsh optional variables
export CASE_SENSITIVE="true"
export ENABLE_CORRECTION="true"
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
    # Theme
    ZSH_THEME="jonathan"

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
    
    # Load Oh My Zsh
    source "$ZSH/oh-my-zsh.sh"
else
    echo "Warning: Oh My Zsh not found at $ZSH"
fi

# =============================================================================
# COMPLETION SYSTEM
# =============================================================================

# Initialize completion system
autoload -Uz compinit

# Cache completions for better performance
# Check if completion cache exists and is newer than 24 hours
compdump_file="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -f "$compdump_file" ]]; then
    # Check if file is newer than 24 hours (86400 seconds)
    if [[ $(($(date +%s) - $(stat -f %m "$compdump_file" 2>/dev/null || echo 0))) -lt 86400 ]]; then
        compinit
    else
        compinit -C
    fi
else
    compinit -C
fi

# Completion settings
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# Set completion colors if LS_COLORS is available
if [[ -n "$LS_COLORS" ]]; then
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# Add custom functions directory
fpath+=~/.zfunc

# =============================================================================
# ALIASES AND FUNCTIONS
# =============================================================================

# mc hack - Midnight Commander with proper terminal support
alias mc="SHELL=/bin/bash TERM=xterm-256color /opt/homebrew/bin/mc --nosubshell"

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
setopt CORRECT_ALL
setopt NO_BEEP

# =============================================================================

# Quick directory listing
function ll() {
    ls -alF "$@"
}

# =============================================================================
   if [[ -n "$KITTY_INSTALLATION_DIR" ]]; then
     export KITTY_SHELL_INTEGRATION="enabled"
     autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
     kitty-integration
     unfunction kitty-integration
   fi
# =============================================================================

BATTERY_CHARGING="⚡️"
BATTERY_SHOW_WATTS=true
RPROMPT='$(battery_pct_prompt) '"$RPROMPT"

# =============================================================================
# The end
