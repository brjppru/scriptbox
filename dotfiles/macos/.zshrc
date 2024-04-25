#
# brj@.zshrc
#

# 2024.04.25 Woman That Rolls

export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=( colored-man-pages ssh bgnotify ssh-agent ansible brew macos sudo tmux autoupdate zsh-autosuggestions )

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8


ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
bgnotify_threshold=30

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent identities id_oss

# mc hack

#alias mc="SHELL=/bin/bash TERM=xterm-256color /usr/bin/mc --nosubshell"
alias mc="SHELL=/bin/bash TERM=xterm-256color /opt/homebrew/bin/mc --nosubshell"
