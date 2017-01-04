#!/bin/sh

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

LOGPATH=/var/log/dailybackup
LOGFILE=dailybackup_`date +"%Y-%m-%d"`.log
# Old log is considered 30 days old to match 30 days kept backups.
OLDLOGFILE=backup_`date -v-30d +"%Y-%m-%d"`.log

DATESTARTED=`date +"%Y-%m-%d %H:%M:%S"`

REMOTEUSER=backupuser
REMOTEHOST=backupserver.home.nuxx.net
REMOTEPORT=31337
REMOTEVOLUME=/Volumes/BackupVolume/banstyle.nuxx.net

SSHCMD="ssh -p$REMOTEPORT $REMOTEUSER@$REMOTEHOST"

####
## Functions
####

errorcheck()
{
  if [ "${1}" -ne "0" ]; then
    echo "Returned ${1} : ${2}"
    writelog "ERROR! Exiting! Returned ${1} : ${2}"
    exit $1
  fi
}

writelog()
{
  echo `date +"%Y-%m-%d %H:%M:%S"` ": ${1}" >> $LOGPATH/$LOGFILE
}

####
## Script Body
####

# Here we go...
writelog "Beginning Backup"

# If the old local log file exists, delete it.
if [ -e $LOGPATH/$OLDLOGFILE ]; then
  rm $LOGPATH/$OLDLOGFILE
  errorcheck $? "Deleting $LOGPATH/$OLDLOGFILE"
  writelog "Deleted $LOGPATH/$OLDLOGFILE"
fi

# If backup.0/backup_complete flag file exists on target, run rotate backup script on target.
$SSHCMD ls $REMOTEVOLUME/backup.0/backup_complete > /dev/null 2>&1
if [ "$?" -eq 0 ]; then
  writelog "$REMOTEVOLUME/backup.0/backup_complete found, rotating backups"
  $SSHCMD $REMOTEVOLUME/scripts/rotatebackups.sh
  errorcheck $? "Running $REMOTEVOLUME/scripts/rotatebackups.sh"
  writelog "Ran Backup Rotation Script on $REMOTEHOST"

  # Check to see if backup.1 exists on target.
  $SSHCMD ls $REMOTEVOLUME/backup.1 > /dev/null 2>&1
  errorcheck $? "Checking for $REMOTEVOLUME/backup.1 on $REMOTEHOST"
  writelog "Confirmed $REMOTEVOLUME/backup.1 Exists on $REMOTEHOST"

  # Create backup.0 on target.
  $SSHCMD mkdir $REMOTEVOLUME/backup.0
  errorcheck $? "Creating $REMOTEVOLUME/backup.0 on $REMOTEHOST"
  writelog "$REMOTEVOLUME/backup.0 Created on $REMOTEHOST"
else
  writelog "$REMOTEVOLUME/backup.0/backup_complete not found, continuing without rotation"
fi

# Create backup_started flag file in backup.0 on target.
$SSHCMD echo "Backup Started at " $DATESTARTED \> $REMOTEVOLUME/backup.0/backup_started
errorcheck $? "Writing Start Time to $REMOTEVOLUME/backup.0/backup_started on $REMOTEHOST"
writelog "Wrote Start Time to $REMOTEVOLUME/backup.0/backup_started on $REMOTEHOST"

# Back things up to target.
#  --bwlimit=64 for normal usage
writelog "Beginning rsync"
rsync -ae"ssh -2 -C -cblowfish -p$REMOTEPORT" \
  --numeric-ids \
  --stats \
  --progress \
  --bwlimit=64 \
  --checksum \
  --exclude-from=/usr/local/etc/dailybackup_exclude \
  --link-dest=../backup.1 \
  /home/. $REMOTEUSER@$REMOTEHOST:$REMOTEVOLUME/backup.0/. \
  >> $LOGPATH/$LOGFILE 2>&1

# Run errorcheck() but only of the exit code isn't 0 or 24, which is
#  "Partial transfer due to vanished source files" and unimportant.
RSYNCEXIT=$?
if [ "$RSYNCEXIT" -ne 0 -a "$RSYNCEXIT" -ne 24 ]; then
  errorcheck $RSYNCEXIT "Running rsync"
fi

writelog "rsync Complete"

# Create backup_complete flag in place of backup_started in backup.0 on target.
DATECOMPLETE=`date +"%Y-%m-%d %H:%M:%S"`
$SSHCMD rm $REMOTEVOLUME/backup.0/backup_started > /dev/null 2>&1
writelog "Deleted $REMOTEVOLUME/backup.0/backup_started on $REMOTEHOST"
$SSHCMD echo "Backup Started at " $DATESTARTED \> $REMOTEVOLUME/backup.0/backup_complete
errorcheck $? "Writing Start Time to $REMOTEVOLUME/backup.0/backup_complete on $REMOTEHOST"
$SSHCMD echo "Backup Complete at " $DATECOMPLETE \>\> $REMOTEVOLUME/backup.0/backup_complete
errorcheck $? "Writing End Time to $REMOTEVOLUME/backup.0/backup_complete on $REMOTEHOST"
writelog "Wrote Start and End Time to $REMOTEVOLUME/backup.0/backup_complete on $REMOTEHOST"

# All done!
writelog "Backup Complete"

