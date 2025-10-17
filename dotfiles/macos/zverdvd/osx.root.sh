#!/usr/bin/env bash

# brj@.macos X configuration - ROOT LEVEL SETTINGS
# This script contains macOS settings that require root privileges

# 2025.10.17 first fork ()

# This script MUST be run as root
if [[ $EUID -ne 0 ]]; then
  printf "This script must be run as root. Please run: sudo $0\n" | fold -s -w 80
  exit 1
fi

# Update existing `sudo` timestamp until `.osx.root` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# System Configuration (requires root)                                       #
###############################################################################

# Restart automatically if the computer freezes
systemsetup -setrestartfreeze on

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

# Restart spotlight
killall mds > /dev/null 2>&1

###############################################################################
# Kill/restart affected applications                                          #
###############################################################################

# Restart affected applications if `--no-restart` flag is not present.
if [[ ! ($* == *--no-restart*) ]]; then
  for app in "cfprefsd" "Dock" "Finder" "Mail" "SystemUIServer" "Terminal"; do
    killall "${app}" > /dev/null 2>&1
  done
fi

printf "Root-level settings applied. Please log out and log back in to make all settings take effect.\n"
