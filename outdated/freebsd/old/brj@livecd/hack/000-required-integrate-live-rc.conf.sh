#!/bin/sh

###
###  brj@integrate hack - интегрирует в дистрибутив brj@livecd
###

if [ -f ../config ] ; then
   . ../config
fi
   
if [ ! -f ${LIVEDIR}/config ]; then
        echo "Sorry, cannot run hack. Cannot find config file."
	exit 2
fi

###
### Real Hack start here
###

        cp ${LIVEDIR}/files/etc/* ${CHROOTDIR}/etc

	# Создаем vnodes необходимые для монтирования виртуальных образов
	    
	cd ${CHROOTDIR}/dev
		
	for i in 0 1 2 3 4 5 6 7 8 9
	do
	    ./MAKEDEV vn$i
	done;
