#!/bin/bash

exit 0

# sensor_id=1 - brj@bvt - 00:13:8f:62:ff:01
# sensor_id=2 - rtzra@dimov - 00:13:8f:62:ff:02
# sensor_id=3 - future plan's

SENSORMAC="00:13:8f:62:ff:01"

cd /root

while true
do

    #tmp24.ru bazo

    DT24=`/bin/date "+%Y-%m-%d"`
    TM24=`/bin/date "+%H:%M:%S"`
    TMP24=`/usr/bin/digitemp_DS9097 -c /root/.digitemprc -t 0 -s /dev/ttyUSB0 -q -o "%.2C"`
    echo "$DT24 $TM24 $TMP24" >> /root/pogoda
    curl http://tmp24.ru/data/ -d "date=$DT24%20$TM24&sensor_id=1&temp=$TMP24"
    sleep 30

   # narodmon

    echo "#${SENSORMAC}" > /var/log/narodmon
    /usr/bin/digitemp_DS9097 -c /root/.digitemprc -t 0 -s /dev/ttyUSB0 -q -i | awk '{FS=" "; if($2==":") { mac[NR-1]=$1;}; if($4=="Sensor") { print "#"mac[$5]"#"$7;}}' >> /var/log/narodmon
    echo "##" >> /var/log/narodmon
    LC=`cat /var/log/narodmon | wc -l`
    if [ $LC -gt 2 ]
     then cat /var/log/narodmon | nc narodmon.ru 8283 > /var/log/narodmon.log
    fi

done
