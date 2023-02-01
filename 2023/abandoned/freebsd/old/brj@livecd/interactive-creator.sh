#!/bin/sh

# ------------------------------------------------------------------------->
# brj@livecd ����� ������� ������� �� ������������ ROOT.
# ------------------------------------------------------------------------->

if [ "`id -u`" != "0" ]; then
        echo "Sorry, brj@livecd must be done as root."
	exit 1
fi

# ------------------------------------------------------------------------->
# brj@livecd ��������� �� ����� �� � ��� ������
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
    "1" "������� ����� ��� ��������� ������������ (mtree)" \
    "2" "������� �������� ����� ������� (buildworld)" \
    "3" "���������� �������� ����� ������� (installworld)" \
    "4" "������� ���� ������������ (buildkernel)" \
    "5" "���������� ���� ������������ (installkernel)" \
    "6" "������� ������ ��� ��������� �� brj@livecd (pkgsel)" \
    "7" "������� ������ ��� ��������� �� brj@livecd (pkg)" \
    "8" "���������� ��������� ������ �� brj@livecd (pkginst)" \
    "H"	"������� ���� ��� ���������� �� brj@livecd" \
    "9" "��������� ��� ���� �� ����������� brj@livecd (dohack)" \
    "A"	"������� ����� ����� � ISO (iso)" \
    "B" "�������� CDRW ������� (blankrw)" \
    "C" "�������� ����������� �� ������� (burncd)" \
    "D" "����� �� ����� ���� � ������� (exit)" 2> /tmp/menu.tmp.$$

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

# ������ ��, ��� �������.

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
    