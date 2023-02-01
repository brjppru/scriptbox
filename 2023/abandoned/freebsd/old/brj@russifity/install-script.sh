#!/bin/sh

brjprog=$(realpath $0)

cleanExit() {
	rm -f ${choices}
	exit ${1:-0}
}

trap 'cleanExit 1' 1 2 3 5 15	# HUP, INT, QUIT, TRAP, TERM

choices=${TMP:-/tmp}/_brj_choices.$$

if [ "`id -u`" != "0" ]; then 
	echo "Sorry, install brj@russifity must be done as root." 
	exit 1 
fi 

clear

/usr/bin/dialog --title "brj@mobile russifity" --clear \
	--checklist "\nPlease specify which components of brj@russifity you\n\
are interested in or simply press return for exit setup  \n\
system. If you would like to patch rc.conf, for example, \n\
then select brj-rc.conf. \n
Which of the following u wont to install? \n" \
	-1 -1 3 \
	"brj-font" "brj@mobile console font" OFF \
        "brj-keys" "brj@mobile keymap font" OFF \
	"brj-rc.d" "brj@mobile /etc/rc.d patch" OFF 2> ${choices} || cleanExit 0

whatinst="`cat ${choices} | tr -d '\"'`"

clear

echo "brj@russifity installiation:\n"
echo "Unpacking files to /tmp dir"

cd /tmp

uudecode -c $brjprog

for inst in ${whatinst:-DEFAULT}
do
	case ${inst:-NULL} in

	brj-font)
		title="brj@font"
		cp /tmp/cp866-8x16.fnt /usr/share/syscons/fonts
                rm /tmp/cp866-8x16.fnt
		;;
	brj-keys)
		title="brj@keys"
		cp /tmp/ru.koi8-r.kbd  /usr/share/syscons/keymaps
                rm /tmp/ru.koi8-r.kbd
		;;
	brj-rc.d)
		title="brj@rc.d"
		cat /tmp/rc.conf.addon >> /etc/rc.conf
		rm /tmp/rc.conf.addon
		;;
	esac

	echo "Instaling: ${title}"

	sleep 1
done

echo "all done! see you at http://brj.pp.ru/"

cleanExit 0

exit

# DATA PLACE HERE!

