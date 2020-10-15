#!/bin/sh

exit 0

clear

# ======================================================>
# do ask me?
# ======================================================>

go4it() {

read -r -p "Are you sure? [Y/n]" response
case "$response" in
    [yY][eE][sS]|[yY])
              #if yes, then execute the passed parameters
               echo "gotcha!"
               ;;
    *)
              #Otherwise exit...
              echo "ciao..."
              exit
              ;;
esac

}

# ======================================================>
# start here
# ======================================================>

clear

# blkid -o udev

# find backup hdd

hddsel=`blkid | sed -n 's/.*UUID=\"\([^\"]*\)\".*/\1/p' | sort`

echo $hddsel

case $hddsel in

    # ntfs
    *"762f6b0c-02"*) hdd="zalman" ;;
    *"A416282C162801C2"*) hdd="black" ;;
    *"4cb39219-01"*) hdd="wd1tb" ;;

    # ext4
    *"c9ab51bd-010c-4898-a869-e5d24f50448f"*) hdd="white" ;;
    *"3bdbe040-01"*) hdd="usb30" ;;
    *"6ccb2f2f-01"*) hdd="1tb" ;;

    # plextor ssd exfat
    *"52b00064-ebdf-43ad-9523-3165d7c78b2e"*) hdd="plextor";;

    # usb2.0 black 1tb offline exfat
    *"07a7b38a-409e-4d85-9852-e6b734e43232"*) hdd="black1tb";;

    # orion 500 7200 hdd 500
    *"c160d409-6439-43dc-8b2e-f8cc156fedeb"*) hdd="orion500";;
    *"524c2d5d-38e6-4190-b9cd-350a1b45dd19"*) hdd="500orion";;

    # hgst 5400 backup 500 gb
    *"d5954d15-2bb0-4cc5-87db-6b7cdbd0121a"*) hdd="hgst500";;

esac

# HDD find done do mount

mkdir -p /mnt/offline
umount -l /mnt/offline

# fusermount -uz

echo "==== mount is here ====="
echo $hdd | figlet

# =============================================================
# fsck block
# =============================================================

echo "\n0st. begin fsck"; go4it;

case "$hdd" in

    "wd1tb")		ntfsfix   `blkid | grep "brj@backup" | cut -d ":" -f1` ;;
    "plextor")		ntfsfix   `blkid | grep "plextor" | cut -d ":" -f1` ;;
    "black1tb")		ntfsfix   `blkid | grep "black1tb" | cut -d ":" -f1` ;;
    "zalman")		ntfsfix   `blkid | grep "zalman" | cut -d ":" -f1` ;;
    "orion500")		fsck	  `blkid | grep "orion500" | cut -d ":" -f1` ;;
    "500orion")		fsck	  `blkid | grep "500orion" | cut -d ":" -f1` ;;
    "hgst500")		fsck	  `blkid | grep "hgst500" | cut -d ":" -f1` ;;

esac

# =============================================================
# mount fs block
# =============================================================

case "$hdd" in

    #ext4
    "usb30")	mount UUID=48004d6a-da8a-436b-a3a3-8a85e0431fac /mnt/offline  -o data=writeback,noatime,nodiratime;;
    "white")	mount UUID=c9ab51bd-010c-4898-a869-e5d24f50448f /mnt/offline  -o data=writeback,noatime,nodiratime;;
    "1tb")	mount UUID=40e0fba2-49bc-4ee0-a283-c28ef8a2b91e /mnt/offline  ;;

    "orion500")	mount UUID=2b8568c7-c8ff-4d45-9f60-86e9797ae1ec /mnt/offline  -o data=writeback,noatime,nodiratime;;
    "500orion")	mount UUID=d9b6cd9b-0083-40c8-92a0-ea421c90f1ca /mnt/offline  -o data=writeback,noatime,nodiratime;;

    # exfat ssd
    "plextor")	mount -t ntfs-3g UUID=540656DC0656BF24 /mnt/offline  -o defaults,journal,noatime,nodiratime,big_writes,locale=ru_RU.utf8,uid=0,gid=0,dmask=0002,fmask=0003;;

    # exfat for 1tb usb black 2.0
    "black1tb")	mount -t ntfs-3g UUID=2DC20ABC754F84AB /mnt/offline  -o defaults,journal,noatime,nodiratime,big_writes,locale=ru_RU.utf8,uid=0,gid=0,dmask=0002,fmask=0003;;

    #ntfs
    "zalman")	mount -t ntfs-3g UUID=5C78B3AA78B380F6 /mnt/offline  -o defaults,journal,noatime,nodiratime,big_writes,locale=ru_RU.utf8,uid=0,gid=0,dmask=0002,fmask=0003;;

    # hgst 500 
    "wd1tb")	mount -t ntfs-3g UUID=5E2484FC2484D903 /mnt/offline  -o defaults,journal,noatime,nodiratime,big_writes,locale=ru_RU.utf8,uid=0,gid=0,dmask=0002,fmask=0003;;

esac

# =============================================================
# mount is done
# =============================================================

echo "\n==== fs is here ====="
mount -t ext4,ntfs,fuseblk | grep -v docker | boxes
df -l -h  /mnt/offline
echo "\n==== mount is here ====="
ls -la /mnt/offline
echo "\n==== mount is here ====="
cat /mnt/offline/hdd.txt

echo "\n1st. mounted begin backup"; go4it;

mkdir -p /mnt/offline/backup

# ======================================================>
# do backup
# ======================================================>

smartctl -d sat -a /dev/sdb > /mnt/offline/backup/smart-sdb-`date +"%Y-%m-%d"`.txt
smartctl -a /dev/sda > /mnt/offline/backup/smart-sda-`date +"%Y-%m-%d"`.txt

rsync --delete-during --info=progress2 -vrltDW /backup/mine /mnt/offline/backup/
rsync --delete-during --info=progress2 -vrltDW --exclude-from=/backup/dropbox/exclude.txt /root/Dropbox /mnt/offline/backup/

case "$hdd" in

    "wd1tb" | "hgst500" | "orion500" | "500orion" )
	    rsync --delete-during --info=progress2 -vrltDW --exclude=education/ /baza /mnt/offline/backup/
	    rsync --delete-during --info=progress2 -vrltDW /backup/elka777 /mnt/offline/backup/
	    ;;

esac

case "$hdd" in

     "wd1tb" | "zalman" |"black1tb")
	    rsync --delete-during --info=progress2 -vrltDW /baza /mnt/offline/backup/
	    rsync --delete-during --info=progress2 -vrltDW /backup/elka777 /mnt/offline/backup/
	    ;;

esac

date > /mnt/offline/backup/backup-`date +"%Y-%m-%d"`.txt

# ======================================================>
# complete
# ======================================================>

sync
sync
sync
sync
umount -l /mnt/offline
sync

echo "# ======================================================>"
blkid -o list
echo "# ======================================================>"

#scsi_stop /dev/sdb
sg_start -r -i 0 -v -S /dev/sdb


echo "backup complete" | figlet

echo "bace brj.home backup to $hdd complete (`date`)" | vtlg

# ======================================================>
# The End ;-)
# ======================================================>
