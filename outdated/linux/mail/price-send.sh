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

	if [ `ls -la ${DATADIR}/diff.txt | /ffp/bin/awk '{print $5}'` -ne 0 ]; then
	
	
	    echo "Content-Type: text/plain; charset=windows-1251" > ${DATADIR}/mailmsg.txt
	    echo "Content-Transfer-Encoding: 8bit" >> ${DATADIR}/mailmsg.txt
	    echo "To: sam@brj.pp.ru" > ${DATADIR}/mailmsg.txt
	    echo "Subject: diff price.krasnoyarsk.ru" >> ${DATADIR}/mailmsg.txt
	    echo " " >> ${DATADIR}/mailmsg.txt
	    echo "[`date`]" >> ${DATADIR}/mailmsg.txt
	    echo " " >> ${DATADIR}/mailmsg.txt
	    cat ${DATADIR}/diff.txt | grep  "+m('" >> ${DATADIR}/mailmsg.txt
	    cat ${DATADIR}/mailmsg.txt | /opt/bin/msmtp --syslog=on --file /ffp/brj/.msmtprc "sam@brj.pp.ru"
	    rm ${DATADIR}/diff.txt
	    rm ${DATADIR}/mailmsg.txt
	fi
   
exit 0
