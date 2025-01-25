#
# brj@.bashrc
#

# 2024.09.04 reborn

# check for interactive
[[ $- = *i* ]] || return

# disable XON/XOFF flow control; enables use of C-S in other commands
# examples: forward search in history; disable screen freeze in vim
[[ $- == *i* ]] && stty -ixon

# --- history define

export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd *"
HISTCONTROL=ignoredups:ignorespace
PROMPT_COMMAND="history -a"

HISTSIZE=
HISTFILESIZE=
HISTFILE=~/.bash_unlimited_history
shopt -s histverify	   # edit a recalled history line before executing

PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
# don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# add a timestamp per entry; useful for context when viewing logfiles.
HISTTIMEFORMAT="%FT%T  "

# re-edit a history substitution line if it failed
shopt -s histreedit

# edit a recalled history line before executing
shopt -s histverify

# toggle history off/on for a current shell
alias stophistory="set +o history"
alias starthistory="set -o history"

# bash options ------------------------------------
#
set -o vi                   # Vi mode
set -o noclobber            # do not overwrite files
#
shopt -s autocd             # change to named directory
shopt -s cdable_vars        # if cd arg is not valid, assumes its a var defining a dir
shopt -s cdspell            # autocorrects cd misspellings
shopt -s checkwinsize       # update the value of LINES and COLUMNS after each command if altered
shopt -s cmdhist            # save multi-line commands in history as single line
shopt -s histappend         # do not overwrite history
shopt -s dotglob            # include dotfiles in pathname expansion
shopt -s expand_aliases     # expand aliases
shopt -s extglob            # enable extended pattern-matching features
shopt -s globstar           # recursive globbing
shopt -s progcomp           # programmable completion
shopt -s hostcomplete       # attempt hostname expansion when @ is at the beginning of a word
shopt -s nocaseglob         # pathname expansion will be treated as case-insensitive

set bell-style visual       # visual bell

# backup and timestamp files
bak() { for f in "$@" ; do cp -- "$f" "$f.$(date +%FT%H%M%S).bak" ; done ; }

# top 10 most used commands
cmd10() { history | awk '{print $3}' | sort | uniq -c | sort -rn | head ; }

# replace spaces and non-ascii characters in a filename with underscore
mtg() { for f in "$@" ; do mv -- "$f" "${f//[^a-zA-Z0-9\.\-]/_}" ; done ; }

# process grep
psg() { ps aux | head -n 1; ps auxww | grep --color=auto $1 ; }

# ---- function setting prompt string

bash_prompt() {
    # some colors
    local color_reset="\033[00m"
    local red="\033[01;31m"
    local green="\033[01;32m"
    local yellow="\033[01;33m"
    local blue="\033[01;34m"
    local magenta="\033[01;35m"

    # red for root, green for others
    local host_color=$(if [[ $UID == 0 ]]; then echo "$red"; else echo "$green"; fi)

    # colorized return value of last command
    local ret="\$(if [[ \$? == 0 ]]; then echo \"\[$green\]\$?\"; else echo \"\[$red\]\$?\"; fi)"

    # blue for writable directories, yellow for non-writable directories
    local dir="\$(if [[ -w \$PWD ]]; then echo \"\[$blue\]\"; else echo \"\[$yellow\]\"; fi)\w"

    # configuration for __git_ps1 function
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUPSTREAM="auto"

    # put it all together
    PS1="$ret \[$host_color\]\u@\h\[$color_reset\]:$dir\[$magenta\]\$(__git_ps1)\[$color_reset\]\$ "

    # PROMPT_COMMAND sets the terminal title bar.
    export PROMPT_COMMAND='printf "\033]0;%s at %s\007" "${USER}" "${HOSTNAME%%.*}"'

}

bash_prompt

#if [[ "$TERM" =~ ".*256color.*" && -f ~/.dircolors.256colors ]]; then
if [[ "$TERM" != "linux" && -f ~/.dircolors.256colors ]]; then
    eval $(dircolors ~/.dircolors.256colors)
elif [[ -f ~/.dircolors ]]; then
    eval $(dircolors ~/.dircolors)
fi

export LS_OPTIONS='--color=auto'
eval "`dircolors`"

alias pushme='screen -xRD'
alias lama='lame -m m -k -d -p -q 0 -V 0'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias du='du -h'
alias df='df -h'

alias qb="curl -G -d 'mimetype=text/plain'"

alias ll='ls $LS_OPTIONS -l'

alias lw='SYSTEMD_LESS=FRXMK journalctl -f | ccze'
alias fuckup='systemctl --failed'
alias fuck='sudo $(history -p \!\!)'
alias mutt='TERM=xterm-256color mutt'

#alias tm='tmux attach || tmux new'
export PS1="\[\e[00;32m\][\[\e[0m\]\[\e[00;31m\]\u@\H\[\e[0m\]\[\e[00;32m\]]\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;33m\]\w\[\e[0m\]  \[\e[00;37m\] \[\e[0m\]\[\e[00;31m\]\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

alias tmc='TERM=xterm-256color mc'

set -o notify           # notify of completed background jobs immediately
ulimit -S -c 0          # disable core dumps
stty -ctlecho           # turn off control character echoing


# default editor
export EDITOR="mcedit"
export VISUAL=$EDITOR

# more for less
export LESS=-R # use -X to avoid sending terminal initialization
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

source_bash_completion() {
  local f
  [[ $BASH_COMPLETION ]] && return 0
  for f in /{etc,usr/share/bash-completion}/bash_completion; do
    if [[ -r $f ]]; then
      . "$f"
      return 0;
    fi
  done
}

# External config
if [[ -r ~/.dircolors ]] && type -p dircolors >/dev/null; then
  eval $(dircolors -b "$HOME/.dircolors")
fi

source_bash_completion
unset -f source_bash_completion

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
