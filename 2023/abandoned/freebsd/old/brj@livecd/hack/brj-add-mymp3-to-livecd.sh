#!/bin/sh

###
###  brj@mp3 hack - закидывает мою подборку MP3 на дистрибутив
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

    mkdir -p ${CHROOTDIR}/mp3
    
    cp -v /ftp/anon/pub/mp3/brj/* ${CHROOTDIR}/mp3
    