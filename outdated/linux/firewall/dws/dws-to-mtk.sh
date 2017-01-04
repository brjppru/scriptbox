#!/bin/sh

echo "/ip firewall address-list"

#add address=111.221.29.177 comment="msspy" list="msspy"

for i in `cat ip` 
 do
 echo add address=$i comment="msspy" list="msspy"
 done

echo "/ip dns static"

#add address=127.0.0.1 name=vortex.data.microsoft.com

for j in `cat host`
 do
 echo add address=127.0.0.1 name=$j
 done

echo "/ip firewall filter"
echo "add action=reject chain=forward comment="msspy" dst-address-list="msspy" dst-port=80,443 protocol=tcp reject-with=tcp-reset"
echo "/"
echo "quit"
