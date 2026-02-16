#!/bin/sh
#
# Remove 'rc' (removed but not purged) packages
# plus debs autoremove and autoclean.
#

sudo apt-get autoremove -y
sudo apt-get autoclean
printf "\n"

sudo mandb
printf "\n"

dpkg -l | awk '/^rc/{print $2}' | xargs sudo apt-get purge -y
printf "\n"

sudo apt-file update
