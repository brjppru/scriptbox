#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:~/bin
export PATH
HOME=/root
export HOME

# prepare to parse

cd /root/traff
rm /root/traff/out_info.php

/usr/local/bin/curl -v --insecure https://www.g-service.ru/php/out_info.php -o /root/traff/out_info.php

# get parse balance
deneg=`cat /root/traff/out_info.php | /usr/bin/awk -F "</b>" '{print $2}' | /usr/bin/sed 's/ //g' |  /usr/bin/sed -e :a -e 's/<[^>]*>//g;/</N;//ba' |  /usr/bin/awk -F "&nbsp;" '{print $1}'`

# get parse internet counter
traf_inet=`cat /root/traff/out_info.php | /usr/bin/awk -F "</div>" '{print $7}' | /usr/bin/sed 's/ //g' | /usr/bin/sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | cut -c 15-40 | cut -f1 -d"&"`

# get parse piring traffic
traf_local=`cat /root/traff/out_info.php | /usr/bin/awk -F "</div>" '{print $8}' | /usr/bin/sed 's/ //g' | /usr/bin/sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | cut -c 17-45 | cut -f1 -d"&"`

# precount
final_inet=`/bin/echo $traf_inet"000" | /usr/bin/awk '{ sum=$1 ; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}'`
final_local=`/bin/echo $traf_local"000" | /usr/bin/awk '{ sum=$1 ; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}'`

# send it to me

echo "deneg na schete $deneg rub" | /usr/bin/mail -s "dogovor 43185 igra-servis" ololo@mail.ru
/usr/local/bin/curl -v -d "text=dogovor igra-servis deneg: $deneg rub, internet: $final_inet, local traff: $final_local" http://sms.ru/sms/send\?api_id=ololo

