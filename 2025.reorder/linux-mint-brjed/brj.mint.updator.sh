#!/bin/bash -x

# Stop on first error
set -e

export DEBIAN_FRONTEND=noninteractive

# =========================================================
# beroot
# =========================================================

beroot() {

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

}

# =========================================================
# begin up keys + ppa
# =========================================================

beroot

# =========================================================
# sysup
# =========================================================

sysup() {

    figlet "keysdb"
    sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com `sudo aptitude update 2>&1 | grep -o '[0-9A-Z]\{16\}$' | xargs`

    # force update
    figlet "update"
    sudo apt-get -y update

    figlet "dist-up"
    sudo apt-get -y dist-upgrade

    figlet "force deps"
    sudo apt-get -y -f install

    figlet "remove"
    sudo apt-get -y autoremove

    figlet "autoclean"
    sudo apt-get -y autoclean
    sudo apt-get -y clean

    figlet "fck old packages"
    sudo dpkg -l | grep ^rc | awk '{print($2)}' | xargs sudo apt-get purge -y
    sudo dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | grep -v linux-libc-dev | xargs sudo apt purge -y

    figlet "apt file update"
    sudo apt-file update

    figlet "update db"
    sudo updatedb
    sudo mandb

    sudo rm "/var/crash/*"
    figlet "done"
}

# "

sysup

# =========================================================
# The end
# =========================================================

