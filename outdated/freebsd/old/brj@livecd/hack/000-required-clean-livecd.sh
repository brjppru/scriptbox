#!/bin/sh

###
###  brj@postclean hack - удаляет с дистрибутива то, что мне не нужно
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

for i in				\
/COPYRIGHT				\
/sys					\
/var/yp					\
/var/spool/uucp				\
/var/spool/uucppublic			\
/var/preserve				\
/var/msgs				\
/var/heimdal				\
/var/games/				\
/usr/src				\
/usr/share/calendar/de_DE.ISO8859-1	\
/usr/share/calendar/de_DE.ISO8859-15	\
/usr/share/calendar/de_DE.ISO_8859-1	\
/usr/share/calendar/de_DE.ISO_8859-15	\
/usr/share/calendar/fr_FR.ISO8859-1	\
/usr/share/calendar/fr_FR.ISO8859-15	\
/usr/share/calendar/hr_HR.ISO8859-2	\
/usr/share/calendar/hr_HR.ISO_8859-2	\
/usr/share/calendar/calendar.australia	\
/usr/share/calendar/calendar.croatian	\
/usr/share/calendar/calendar.freebsd	\
/usr/share/calendar/calendar.history	\
/usr/share/calendar/calendar.holiday	\
/usr/share/calendar/calendar.judaic	\
/usr/share/calendar/calendar.music	\
/usr/share/calendar/calendar.newzealand	\
/usr/share/calendar/calendar.usholiday	\
/usr/share/dict				\
/usr/share/games/			\
/usr/share/isdn/			\
/usr/share/libg++			\
/usr/share/man/cat1			\
/usr/share/man/cat1aout			\
/usr/share/man/cat2			\
/usr/share/man/cat3			\
/usr/share/man/cat4			\
/usr/share/man/cat5			\
/usr/share/man/cat6			\
/usr/share/man/cat7			\
/usr/share/man/cat8			\
/usr/share/man/cat9			\
/usr/share/man/catn			\
/usr/share/man/en.ISO8859-1		\
/usr/share/man/en.ISO8859-15		\
/usr/share/man/ja			\
/usr/share/openssl/man/cat1		\
/usr/share/openssl/man/cat3		\
/usr/share/openssl/man/en.ISO8859-1	\
/usr/share/sendmail			\
/usr/obj				\
/usr/local/share/xml			\
/usr/local/share/skel			\
/usr/local/share/sgml			\
/usr/local/share/misc			\
/usr/local/share/java			\
/usr/local/share/dict			\
/usr/local/man/cat1			\
/usr/local/man/cat2			\
/usr/local/man/cat3			\
/usr/local/man/cat4			\
/usr/local/man/cat5			\
/usr/local/man/cat6			\
/usr/local/man/cat7			\
/usr/local/man/cat8			\
/usr/local/man/cat9			\
/usr/local/man/catn			\
/usr/local/man/catl			\
/usr/local/man/de.ISO8859-1		\
/usr/local/man/en.ISO8859-1		\
/usr/local/man/ja			\
/usr/games				\
/etc/X11				\
/etc/gnats				\
/etc/isdn				\
/etc/kerberosIV				\
/etc/skel				\
/etc/uucp
do
	    chflags -R noschg ${CHROOTDIR}$i
            rm -rfv ${CHROOTDIR}$i
done
