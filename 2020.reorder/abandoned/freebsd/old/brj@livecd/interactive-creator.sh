#!/bin/sh

# ------------------------------------------------------------------------->
# brj@livecd можно создать работая от пользователя ROOT.
# ------------------------------------------------------------------------->

if [ "`id -u`" != "0" ]; then
        echo "Sorry, brj@livecd must be done as root."
	exit 1
fi

# ------------------------------------------------------------------------->
# brj@livecd проверяем на месте ли у нас конфиг
# ------------------------------------------------------------------------->

if [ -f ./config ] ; then
   . ./config
fi

if [ ! -f ${LIVEDIR}/config ]; then
        echo "Sorry, brj@livecd cannot find config file."
	exit 2
fi

LIVESCRIPT=${LIVEDIR}/brj@livecd.sh

main-dialog() {

${DIALOG} --menu "brj@livecd ${RELEASE} interactive creator" 20 70 13 \
    "1" "Создать папку для постоения дистрибутива (mtree)" \
    "2" "Создать бинарные файлы системы (buildworld)" \
    "3" "Установить бинарные файлы системы (installworld)" \
    "4" "Создать ядро дистрибутива (buildkernel)" \
    "5" "Установить ядро дистрибутива (installkernel)" \
    "6" "Выбрать пакеты для установки на brj@livecd (pkgsel)" \
    "7" "Создать пакеты для установки на brj@livecd (pkg)" \
    "8" "Установить выбранные пакеты на brj@livecd (pkginst)" \
    "H"	"Выбрать хаки для применения на brj@livecd" \
    "9" "Выполнить все ХАКИ на дистрибутив brj@livecd (dohack)" \
    "A"	"Создать образ диска в ISO (iso)" \
    "B" "Очистить CDRW матрицу (blankrw)" \
    "C" "Записать дистрибутив на матрицу (burncd)" \
    "D" "Выйти из этого меню в систему (exit)" 2> /tmp/menu.tmp.$$

retval=$?

choice=`cat /tmp/menu.tmp.$$`

rm -f /tmp/menu.tmp.$$

case ${retval} in

  1)
    clear  
    echo "Cancel pressed. brj@livecd interactive shell shutdown..."
    exit 0
    ;;
	    
255)
   [ -z "${choice}" ] || echo ${choice} ;
   clear  
   echo "ESC pressed. brj@livecd interactive shell shutdown..."
   exit 0
   ;;
		      
esac

# Делаем то, что выбрали.

case ${choice} in

    1) 
	clear
	sh ${LIVESCRIPT} mtree
	;;

    2)  
	clear
	sh ${LIVESCRIPT} buildworld
	;;

    3)  
	clear
	sh ${LIVESCRIPT} installworld
	;;

    4)  
	clear
	sh ${LIVESCRIPT} buildkernel
	;;

    5)  
	clear
	sh ${LIVESCRIPT} installkernel
	;;

    6)  
	clear
	sh ${LIVESCRIPT} pkgsel
	;;

    7)  
	clear
	sh ${LIVESCRIPT} pkg
	;;

    8)  
	clear
	sh ${LIVESCRIPT} pkginst
	;;

    H)
	clear
	sh ${LIVESCRIPT} selecthack
	;;

    9)  
	clear
	sh ${LIVESCRIPT} dohack
	;;

    A)  
	clear
	sh ${LIVESCRIPT} iso
	;;

    B)  
	clear
	sh ${LIVESCRIPT} blankrw
	;;

    C)  
	clear
	sh ${LIVESCRIPT} burn
	;;

    D)  
	clear
	echo "Exit selected, brj@livecd interactive shell shutdown..."
	exit 0
	;;
    
esac

}

###
### Mega loop
###

    while true ; do

	main-dialog

    done
    