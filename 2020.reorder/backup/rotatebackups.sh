#!/bin/sh

DIRPREFIX="/Volumes/BackupVolume/banstyle.nuxx.net"

BACKUPSTOKEEP=30

# Delete the last kept, if it is there.
if [ -e $DIRPREFIX/backup.$BACKUPSTOKEEP ]; then
  rm -rf -- $DIRPREFIX/backup.$BACKUPSTOKEEP
fi

# Preload iteration counter.
i=1

# Preload n for backup.n historical copies.
n=`expr $BACKUPSTOKEEP - 1`

while [ $i -le $BACKUPSTOKEEP ]
do
  if [ -e $DIRPREFIX/backup.$n ]; then
    mv $DIRPREFIX/backup.$n $DIRPREFIX/backup.`expr $n + 1`
  fi
  ((n = $n - 1))
  ((i = $i + 1))
done
