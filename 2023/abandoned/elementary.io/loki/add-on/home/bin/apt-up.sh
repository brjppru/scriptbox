#!/bin/sh

    # receive keys
    figlet "upkeys"
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
    figlet "remove old packages"
    sudo dpkg -l | grep ^rc | awk '{print($2)}' | xargs sudo apt-get -y purge
    sudo dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | grep -v linux-libc-dev | xargs sudo apt -y purge
    figlet "update db"
    sudo updatedb
    sudo rm /var/crash/*
    figlet "done"
