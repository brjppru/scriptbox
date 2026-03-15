#!/usr/bin/env zsh
#
# brj@.zshrc
#

# 2024.04.25 initial version
# 2024.06.22 fix autoupdate noise
# 2024.12.19 optimize startup
# 2025.10.17 rewrite, add kitty integration
# 2025.10.24 fix battery prompt
# 2026.01.25 cleanup completion init, path priority, remove global GAC
# 2026.01.26 session: plugins, history, colors, mc aliases, kitty cursor fix
# 2026.03.15 remove oh-my-zsh, move prompt to starship, add zoxide, native compinit, path cleanup
# 2026.03.15 preserve kitty shell_integration flags with manual zsh + starship init

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

# Drop dead inherited PATH entries
typeset -aU clean_path
for dir in $path; do
  [[ -d "$dir" ]] && clean_path+=("$dir")
done
path=($clean_path)
unset clean_path dir

# Zsh caches and completions
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"
[[ -d "/opt/homebrew/share/zsh/site-functions" ]] && fpath=("/opt/homebrew/share/zsh/site-functions" $fpath)
[[ -d "/usr/local/share/zsh/site-functions" ]] && fpath=("/usr/local/share/zsh/site-functions" $fpath)
[[ -d "$HOME/.zfunc" ]] && fpath=("$HOME/.zfunc" $fpath)
typeset -U fpath

# =============================================================================
# COMPLETION SYSTEM
# =============================================================================

# Completion settings
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
if [[ -n "$LS_COLORS" ]]; then
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

zmodload zsh/complist
autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

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
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
unsetopt SHARE_HISTORY

# Globbing
setopt EXTENDED_GLOB
setopt GLOB_COMPLETE

# Other useful options
setopt AUTO_CD
unsetopt CORRECT
setopt NO_BEEP

# =============================================================================

# Quick directory listing
alias ll='ls -alF'

# =============================================================================
if [[ -n "$KITTY_INSTALLATION_DIR" ]]; then
  export KITTY_SHELL_INTEGRATION="${KITTY_SHELL_INTEGRATION:-enabled no-cursor}"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi
# =============================================================================

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# =============================================================================

# =============================================================================
# The end

# Starship prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  print -u2 -- "Warning: starship not found in PATH"
fi
