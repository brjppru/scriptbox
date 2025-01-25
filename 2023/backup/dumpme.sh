#!/bin/sh
#
# brj@gigabackup, http://brj.pp.ru/
# ohooennaya backup filesystem engine (-;
#

# ------------------------------------------------------------------------->
# CONFIG
# ------------------------------------------------------------------------->
#
# put all required filesystems into DUMPS and specify
# DUMPDIR and DUMPVOL

DUMPDIR="/mnt/backup/core2"
DUMPVOL="/mnt/backup"
DUMPS="/var /usr /"
DUMPEMAIL=root@localhost

# ------------------------------------------------------------------------->
# BEGIN
# ------------------------------------------------------------------------->

smbutil login -N -I 192.168.201.6 //l0ner@flash/archive
mount_smbfs -N -I 192.168.201.6 -E koi8-r:cp866 //l0ner@flash/archive /mnt/backup

DATE=`date +%Y-%m-%d`
FREE=`df -k /${DUMPVOL} | tail -n 1 | awk '{print $4}'`

A=0
for i in `df -k /${DUMPS} | awk '{print $3}' | grep -v Used`; do
A="$A + $i"
done

USED=`echo $A | bc`
A=0

dumping ()
{

for i in ${DUMPS}; do

NAME=`echo $i | sed -e 's/\///g'`
[ $i = "/" ] && NAME="root"
echo -e "Dumping $i filesystem on `hostname` started at `date`\n"
dump -a -f ${DUMPDIR}/`hostname`-${NAME}-${DATE} $i

done

echo "Finisted at `date`"
}

if [ -e ${DUMPDIR}/.keepme ]; then

     rm ${DUMPDIR}/`hostname`*
     [ ${FREE} -lt ${USED} ] && ( echo "Not enougth space on backup volume, exiting"; logger -t backup "Not enougth space on backup volume, exiting"; echo "ACHTUNG! BACKUPEN IN DER FLASHEN ON ${DATE} DAS KAPUT!" | mail ${DUMPEMAIL} )
     [ ${FREE} -gt ${USED} ] && dumping

else

    logger -t backup "Not found backup volume, exiting"; 
    echo "ACHTUNG! BACKUPEN IN DER FLASHEN ON ${DATE} DAS KAPUT!" | mail ${DUMPEMAIL}

fi

umount /mnt/backup
smbutil logout -N -I 192.168.201.6 //l0ner@flash/archive

