#!/bin/sh

###
###  имя@хака - скрипт-болванка для написания собственного хака.
###

if [ -f ../config ] ; then
   . ../config
fi
   
if [ ! -f ${LIVEDIR}/config ]; then
        echo "Sorry, cannot run hack. Cannot find config file."
	exit 2
fi

###
### Сам хак начинается тут.
###

    do something on ${CHROOTDIR}/mp3/files
    
    copy something to ${CHROOTDIR}/var/tmp/files

    bla-bla-bla to ${CHROOTDIR}
    
