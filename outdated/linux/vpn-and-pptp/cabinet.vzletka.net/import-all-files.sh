#!/bin/sh

wget "https://cabinet.vzletka.net/admin/_export.aspx?id=6" 

rm /root/cabinet/export.aspx

sleep 10

sh /root/cabinet/sync.sh
