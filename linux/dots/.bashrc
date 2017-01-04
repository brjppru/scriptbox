#
# brj@.bashrc
#

# check for interactive
[[ $- = *i* ]] || return

# bash options ------------------------------------
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

# function setting prompt string
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
}

bash_prompt

# set history variables 
unset HISTFILESIZE
HISTSIZE=100000
HISTCONTROL=ignoredups:ignorespace
# share history across all terminals
PROMPT_COMMAND="history -a"

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

alias ps='ps aux'

alias qb="curl -G -d 'mimetype=text/plain'"

alias ll='ls $LS_OPTIONS -l'

alias mykey='cat ~/.ssh/id_rsa.pub'

alias lw='tail -f /var/log/all.log |ccze'
alias nglw='tail -f /var/log/nginx/access.log /var/log/nginx/error.log | ccze'
#alias lw='SYSTEMD_LESS=FRXMK journalctl -f'
alias fuckup='systemctl --failed'
alias fuck='sudo $(history -p \!\!)'
alias mutt='TERM=xterm-256color mutt'

#alias tm='tmux attach || tmux new'
export PS1="\[\e[00;32m\][\[\e[0m\]\[\e[00;31m\]\u@\H\[\e[0m\]\[\e[00;32m\]]\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;33m\]\w\[\e[0m\]  \[\e[00;37m\] \[\e[0m\]\[\e[00;31m\]\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

alias tmc='TERM=xterm-256color mc'

set -o notify           # notify of completed background jobs immediately
ulimit -S -c 0          # disable core dumps
stty -ctlecho           # turn off control character echoing

# more for less
export LESS=-R # use -X to avoid sending terminal initialization
export LESS_TERMCAP_mb=$'\e[01;31m'
export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

# history
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd *"
export HISTCONTROL="ignoreboth:erasedups"
export HISTSIZE=1000
export HISTFILESIZE=2000

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
