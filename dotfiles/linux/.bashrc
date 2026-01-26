#!/bin/bash
#
# brj@.bashrc - Portable + optimized for Linux/macOS/FreeBSD
# 2024.09.04 reborn - merged and linted
# 2026.01.25 portability pass (OS detect, colors, prompt, completion)
# 2026.01.26 session: history, prompt safety, editor fallback, bash_completion paths
#

# =============================================================================
# INTERACTIVE SHELL CHECK
# =============================================================================
# Only run this file for interactive shells
[[ $- = *i* ]] || return

# =============================================================================
# OS DETECTION
# =============================================================================
case "$(uname -s)" in
    Linux*)   OS_TYPE="linux" ;;
    Darwin*)  OS_TYPE="macos" ;;
    FreeBSD*) OS_TYPE="freebsd" ;;
    *)        OS_TYPE="other" ;;
esac

# disable XON/XOFF flow control; enables use of C-S in other commands
# examples: forward search in history; disable screen freeze in vim
[[ $- == *i* ]] && stty -ixon 2>/dev/null

# =============================================================================
# HISTORY CONFIGURATION
# =============================================================================
# Unlimited history for better command tracking
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd *"
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=100000
HISTFILE=~/.bash_unlimited_history

# Add timestamp to history entries
HISTTIMEFORMAT="%FT%T  "

# History behavior options
shopt -s histverify    # edit a recalled history line before executing
shopt -s histreedit    # re-edit a history substitution line if it failed
shopt -s histappend    # do not overwrite history
shopt -s cmdhist       # save multi-line commands in history as single line

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
shopt -s autocd 2>/dev/null        # change to named directory (bash 4+)
shopt -s cdable_vars   # if cd arg is not valid, assumes its a var defining a dir
shopt -s cdspell       # autocorrects cd misspellings
shopt -s checkwinsize  # update the value of LINES and COLUMNS after each command if altered
shopt -s dotglob       # include dotfiles in pathname expansion
shopt -s expand_aliases # expand aliases
shopt -s extglob       # enable extended pattern-matching features
shopt -s globstar 2>/dev/null      # recursive globbing (bash 4+)
shopt -s progcomp      # programmable completion
shopt -s hostcomplete 2>/dev/null  # attempt hostname expansion when @ is at the beginning of a word
shopt -s nocaseglob    # pathname expansion will be treated as case-insensitive

# Visual bell instead of beep
bind 'set bell-style visible' 2>/dev/null

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================
# Backup files with timestamp
bak() { 
    for f in "$@"; do 
        local src="$f"
        [[ "$src" == -* ]] && src="./$src"
        local dst
        dst="$f.$(date +%FT%H%M%S).bak"
        [[ "$dst" == -* ]] && dst="./$dst"
        cp -p "$src" "$dst"
    done
}

# Show top 10 most used commands
cmd10() {
    # Extract the command from history lines robustly, ignoring timestamps/indices
    history | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+//' \
        | sed -E 's/^[0-9-]+[[:space:]]+[0-9:]+[[:space:]]+//' \
        | awk '{print $1}' | sort | uniq -c | sort -rn | head
}

# Replace spaces and non-ascii characters in filename with underscore
mtg() { 
    for f in "$@"; do 
        local src="$f"
        [[ "$src" == -* ]] && src="./$src"
        local dst
        dst="${f//[^a-zA-Z0-9\.\-]/_}"
        [[ "$dst" == -* ]] && dst="./$dst"
        mv "$src" "$dst"
    done
}

# Process grep with proper quoting
psg() { 
    ps aux | head -n 1
    ps auxww | grep "$1"
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
    PS1="$ret \[$host_color\]\u@\h\[$color_reset\]:$dir\[$magenta\]\$(__brj_git_ps1)\[$color_reset\]\$ "
}

# Optional git prompt (portable paths)
for _git_prompt in \
    /usr/share/git/completion/git-prompt.sh \
    /usr/lib/git-core/git-sh-prompt \
    /usr/local/share/git/completion/git-prompt.sh \
    /opt/homebrew/share/git/completion/git-prompt.sh \
    /usr/local/etc/bash_completion.d/git-prompt.sh \
    /opt/homebrew/etc/bash_completion.d/git-prompt.sh \
    /usr/local/share/bash-completion/completions/git-prompt.sh \
    /usr/local/share/bash-completion/git-prompt.sh; do
    if [[ -r "$_git_prompt" ]]; then
        # shellcheck source=/dev/null
        . "$_git_prompt"
        break
    fi
done
unset _git_prompt

__brj_git_ps1() {
    type __git_ps1 >/dev/null 2>&1 && __git_ps1
}

# Append to history file and set terminal title
_brj_prompt_command() {
    history -a
    printf "\033]0;%s at %s\007" "${USER}" "${HOSTNAME%%.*}"
}
if [[ "$PROMPT_COMMAND" != *"_brj_prompt_command"* ]]; then
    if [[ -n "$PROMPT_COMMAND" ]]; then
        PROMPT_COMMAND="_brj_prompt_command; $PROMPT_COMMAND"
    else
        PROMPT_COMMAND="_brj_prompt_command"
    fi
fi

# Initialize the prompt
bash_prompt

# =============================================================================
# COLORS AND DIRCOLORS
# =============================================================================
# Set up ls colors and options per OS
case "$OS_TYPE" in
    linux)
        export LS_OPTIONS='--color=auto'
        if command -v dircolors >/dev/null 2>&1; then
            if [[ "$TERM" != "linux" && -f ~/.dircolors.256colors ]]; then
                eval "$(dircolors ~/.dircolors.256colors)"
            elif [[ -f ~/.dircolors ]]; then
                eval "$(dircolors ~/.dircolors)"
            else
                eval "$(dircolors)"
            fi
        fi
        ;;
    macos|freebsd)
        export CLICOLOR=1
        export LSCOLORS="Gxfxcxdxbxegedabagacad"
        export LS_OPTIONS='-G'
        ;;
    *)
        export LS_OPTIONS=''
        ;;
esac

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
alias ls='ls $LS_OPTIONS'
if grep --color=auto </dev/null >/dev/null 2>&1; then
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
alias ll='ls $LS_OPTIONS -l'

# Human readable sizes
alias du='du -h'
alias df='df -h'

# Web utilities
alias qb="curl -G -d 'mimetype=text/plain'"

# System administration
if command -v journalctl >/dev/null 2>&1; then
    alias lw='SYSTEMD_LESS=FRXMK journalctl -f | ccze'
    alias fuckup='systemctl --failed'
fi
alias fuck='sudo $(history -p \!\!)'

# =============================================================================
# SHELL SETTINGS
# =============================================================================
set -o notify           # notify of completed background jobs immediately
ulimit -S -c 0          # disable core dumps
stty -ctlecho 2>/dev/null           # turn off control character echoing

# =============================================================================
# EDITOR CONFIGURATION
# =============================================================================
if command -v mcedit >/dev/null 2>&1; then
    export EDITOR="mcedit"
elif command -v vim >/dev/null 2>&1; then
    export EDITOR="vim"
elif command -v vi >/dev/null 2>&1; then
    export EDITOR="vi"
elif command -v nano >/dev/null 2>&1; then
    export EDITOR="nano"
fi
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
    for f in \
        /etc/bash_completion \
        /usr/share/bash-completion/bash_completion \
        /usr/local/share/bash-completion/bash_completion \
        /usr/local/etc/bash_completion \
        /opt/homebrew/etc/bash_completion \
        /opt/homebrew/share/bash-completion/bash_completion \
        /usr/local/etc/profile.d/bash_completion.sh \
        /opt/homebrew/etc/profile.d/bash_completion.sh; do
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
