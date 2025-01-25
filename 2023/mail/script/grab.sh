#!/bin/sh

exit 0

#
# price.krasnoyarsk.ru news grabber by brj
#

#
# install for auto check in 15 min write to /etc/crontab
#
# */15    *       *       *       *       root    /etc/crond/zaletka-news.sh > /dev/null 2>&1
#

DATADIR=/ffp/brj/price/data
EMAIL1="sam@brj.pp.ru"

cd ${DATADIR}/

mv ${DATADIR}/news.txt ${DATADIR}/vchera.txt

/usr/bin/wget -O /dev/null "http://price.krasnoyarsk.ru/show.php3?bar=barshow#" > /dev/null 2>&1

if [ $? -eq 0 ]; then
	/usr/bin/wget -q -O - "http://price.krasnoyarsk.ru/show.php3?bar=barshow#" | grep "m('" > ${DATADIR}/news.txt

	/ffp/bin/diff -u ${DATADIR}/vchera.txt ${DATADIR}/news.txt >> ${DATADIR}/diff.txt

	else
	exit 1
fi

exit 0
