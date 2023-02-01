#
# brj@cshrc, see also csh(1), environ(7) for detail, http://brj.pp.ru/
#

# ------------------------------------------------------------------------->
# Описание файловых систем, загрузчика и т.д.
# ------------------------------------------------------------------------->

# Мой PROMPT. Когда пользователем - зеленый, когда рутом - красным.

set 	COLOR1="%{\e[01;32m%}"
set 	COLOR2="%{\e[00;32m%}"
set 	COLOR3="%{\e[00;39m%}"

if( `whoami` == root ) then
	set COLOR2="%{\e[00;31m%}"
endif

set 	prompt="$COLOR1\[$COLOR2`whoami`\@brj.pp.ru$COLOR1] $COLOR2%b%/%b%#$COLOR3 "

# Настройки окружения

set 	path = (/sbin /bin /usr/sbin /usr/bin /usr/local/sbin /usr/local/bin /usr/X11R6/bin $HOME/bin)

set 	LSCOLORS = "cxBxhxFxFxhxCxCxExEx"

set 	filec
set 	history = 500
set 	savehist = 500

umask 	0022
mesg 	y

# Don't overwrite existing files with the redirection character ">"
#set 	noclobber

# Notify me when the status of background jobs change
set 	notify

# Don't let me log out by pressing <ctrl-d>
set 	ignoreeof

# Прочие настройки

setenv	LANG 	en_US.UTF-8

set 	LC_MESSAGES = C
#setenv	LC_MESSAGES = C

setenv	EDITOR	   vim
setenv	PAGER	   more
setenv	BLOCKSIZE  K

# logname for send-pr(1)
setenv	LOGNAME "sam@brj.pp.ru"
setenv	NAME    "Roman Y. Bogdanov"

# X11

set 	GDK_USE_XFT = 0
set 	USE_GDK_XFT = 0

# Алиасы для меня

alias j		jobs -l
alias la	ls -aG
alias lf	ls -FAG
alias ll	ls -aFgloG
alias ls 	ls -GkF
alias l		ls -AFG
alias df	df -h
alias du	du -h
alias c		clear

alias mine	'chmod og-rwx'

alias playit	'mplayer -hardframedrop -af comp,volnorm -osdlevel 3 -loop 0'
alias lameit	'lame -m d -k -d -p -q 0 -b 320'
alias grabit	'dagrab -d /dev/acd0 -v -a'
alias shootme	'import -window root /tmp/screen.png'
alias pushme	'screen -xRD'
alias isiloit	'iSiloBSD'

alias mailsnt	'grep status=sent /var/log/maillog | wc -l'
alias mailrej	'cat /var/log/maillog | grep reject | wc -l'

alias mc        /usr/local/bin/mc -c -a
alias sumc	sudo /usr/local/bin/mc -c -a
alias dfme	df -H -t ufs
alias lw	'tail -f /var/log/all.log | colorize'

alias psg	'ps -auxwww | grep \!* | grep -v grep'

alias qscan	sudo nmap -P0 --osscan_guess -p 21,22,23,25,53,80,110
alias fscan	sudo nmap -v -sT -F -O -P0 -T 1 -M 50
alias bindver	'nslookup -class=chaos -q=txt version.bind'

alias blankrw   burncd -v -f /dev/acd0 -e -s max blank
alias eraserw   burncd -v -f /dev/acd0 -e -s max erase
alias bulkiso	'readcd dev=2,0,0 f=cdimage.raw'
alias burnit	'mkisofs -rJ -jcharset koi8-r . | burncd -s max -e -v -f /dev/acd0 data - fixate'
alias dvdit	'growisofs -Z /dev/cd0 -rJ -jcharset koi8-r .'
alias isoit	'mkisofs -rJ -jcharset koi8-r -o isoit.iso .'
alias dvdinfo	'dvd+rw-mediainfo /dev/cd0'

alias send-pr	"send-pr -s non-critical -c 'Roman Y. Bogdanov <sam@brj.pp.ru>'"

# ------------------------------------------------------------------------->
# The END
# ------------------------------------------------------------------------->
