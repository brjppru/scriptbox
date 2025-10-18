#!/bin/bash
#
# brj@.bashrc - Optimized for Debian/AlmaLinux servers
# 2024.09.04 reborn - merged and linted
#

# =============================================================================
# INTERACTIVE SHELL CHECK
# =============================================================================
# Only run this file for interactive shells
[[ $- = *i* ]] || return

# disable XON/XOFF flow control; enables use of C-S in other commands
# examples: forward search in history; disable screen freeze in vim
[[ $- == *i* ]] && stty -ixon

# =============================================================================
# HISTORY CONFIGURATION
# =============================================================================
# Unlimited history for better command tracking
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd *"
HISTCONTROL=ignoreboth
HISTSIZE=
HISTFILESIZE=
HISTFILE=~/.bash_unlimited_history

# Add timestamp to history entries
HISTTIMEFORMAT="%FT%T  "

# History behavior options
shopt -s histverify    # edit a recalled history line before executing
shopt -s histreedit    # re-edit a history substitution line if it failed
shopt -s histappend    # do not overwrite history
shopt -s cmdhist       # save multi-line commands in history as single line

# Append to history file after each command
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Toggle history on/off for current shell
alias stophistory="set +o history"
alias starthistory="set -o history"

# =============================================================================
# BASH OPTIONS
# =============================================================================
# Vi mode for command line editing
set -o vi
set -o noclobber       # do not overwrite files

# Shell options for better user experience
shopt -s autocd        # change to named directory
shopt -s cdable_vars   # if cd arg is not valid, assumes its a var defining a dir
shopt -s cdspell       # autocorrects cd misspellings
shopt -s checkwinsize  # update the value of LINES and COLUMNS after each command if altered
shopt -s dotglob       # include dotfiles in pathname expansion
shopt -s expand_aliases # expand aliases
shopt -s extglob       # enable extended pattern-matching features
shopt -s globstar      # recursive globbing
shopt -s progcomp      # programmable completion
shopt -s hostcomplete  # attempt hostname expansion when @ is at the beginning of a word
shopt -s nocaseglob    # pathname expansion will be treated as case-insensitive

# Visual bell instead of beep
set bell-style visual

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================
# Backup files with timestamp
bak() { 
    for f in "$@"; do 
        cp -- "$f" "$f.$(date +%FT%H%M%S).bak"
    done
}

# Show top 10 most used commands
cmd10() { 
    history | awk '{print $3}' | sort | uniq -c | sort -rn | head
}

# Replace spaces and non-ascii characters in filename with underscore
mtg() { 
    for f in "$@"; do 
        mv -- "$f" "${f//[^a-zA-Z0-9\.\-]/_}"
    done
}

# Process grep with proper quoting
psg() { 
    ps aux | head -n 1
    ps auxww | grep --color=auto "$1"
}

# =============================================================================
# PROMPT CONFIGURATION
# =============================================================================
bash_prompt() {
    # Color definitions
    local color_reset="\033[00m"
    local red="\033[01;31m"
    local green="\033[01;32m"
    local yellow="\033[01;33m"
    local blue="\033[01;34m"
    local magenta="\033[01;35m"

    # Red for root, green for others
    local host_color
    if [[ $UID == 0 ]]; then 
        host_color="$red"
    else 
        host_color="$green"
    fi

    # Colorized return value of last command
    local ret="\$(if [[ \$? == 0 ]]; then echo \"\[$green\]\$?\"; else echo \"\[$red\]\$?\"; fi)"

    # Blue for writable directories, yellow for non-writable directories
    local dir="\$(if [[ -w \$PWD ]]; then echo \"\[$blue\]\"; else echo \"\[$yellow\]\"; fi)\w"

    # Git prompt configuration (export for external use)
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUPSTREAM="auto"

    # Assemble the prompt
    PS1="$ret \[$host_color\]\u@\h\[$color_reset\]:$dir\[$magenta\]\$(__git_ps1)\[$color_reset\]\$ "

    # Set terminal title bar
    export PROMPT_COMMAND='printf "\033]0;%s at %s\007" "${USER}" "${HOSTNAME%%.*}"'
}

# Initialize the prompt
bash_prompt

# =============================================================================
# COLORS AND DIRCOLORS
# =============================================================================
# Set up dircolors for better file listing
export LS_OPTIONS='--color=auto'

# Load dircolors configuration (only once)
if [[ "$TERM" != "linux" && -f ~/.dircolors.256colors ]]; then
    eval "$(dircolors ~/.dircolors.256colors)"
elif [[ -f ~/.dircolors ]]; then
    eval "$(dircolors ~/.dircolors)"
else
    eval "$(dircolors)"
fi

# =============================================================================
# ALIASES
# =============================================================================
# Screen and terminal
alias pushme='screen -xRD'
alias tmc='TERM=xterm-256color mc --nosubshell'
alias mutt='TERM=xterm-256color mutt'

# Audio processing
alias lama='lame -m m -k -d -p -q 0 -V 0'

# File operations with colors
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls $LS_OPTIONS -l'

# Human readable sizes
alias du='du -h'
alias df='df -h'

# Web utilities
alias qb="curl -G -d 'mimetype=text/plain'"

# System administration
alias lw='SYSTEMD_LESS=FRXMK journalctl -f | ccze'
alias fuckup='systemctl --failed'
alias fuck='sudo $(history -p \!\!)'

# =============================================================================
# SHELL SETTINGS
# =============================================================================
set -o notify           # notify of completed background jobs immediately
ulimit -S -c 0          # disable core dumps
stty -ctlecho           # turn off control character echoing

# =============================================================================
# EDITOR CONFIGURATION
# =============================================================================
export EDITOR="mcedit"
export VISUAL="$EDITOR"

# =============================================================================
# LESS CONFIGURATION
# =============================================================================
export LESS=-R # use -X to avoid sending terminal initialization
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

# =============================================================================
# BASH COMPLETION
# =============================================================================
source_bash_completion() {
    local f
    [[ $BASH_COMPLETION ]] && return 0
    for f in /{etc,usr/share/bash-completion}/bash_completion; do
        if [[ -r $f ]]; then
            # shellcheck source=/dev/null
            . "$f"
            return 0
        fi
    done
}

source_bash_completion
unset -f source_bash_completion

# =============================================================================
# PATH CONFIGURATION
# =============================================================================
# Add user's private bin directory to PATH if it exists
if [[ -d "$HOME/bin" ]]; then
    PATH="$HOME/bin:$PATH"
fi
