#!/usr/bin/env bash

# brj@.macos X configuration - ROOT LEVEL SETTINGS
# This script contains macOS settings that require root privileges

# 2025.10.17 first fork ()
# 2025.12.22 refactor

# This script MUST be run as root
if [[ $EUID -ne 0 ]]; then
  printf "This script must be run as root. Please run: sudo %s\n" "$0" | fold -s -w 80
  exit 1
fi

# Check if Terminal has Full Disk Access
if ! ls ~/Library/Mail/ >/dev/null 2>&1; then
  printf "WARNING: Terminal does not have Full Disk Access.\n"
  printf "Some settings may fail. To fix:\n"
  printf "  1. Open System Settings -> Privacy & Security -> Full Disk Access\n"
  printf "  2. Enable access for Terminal (or your terminal app)\n"
  printf "\nContinue anyway? [y/N] "
  read -r answer
  if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
    exit 1
  fi
fi

# Update existing `sudo` timestamp until `.osx.root` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# System Configuration (requires root)                                       #
###############################################################################

# Restart automatically if the computer freezes
systemsetup -setrestartfreeze on

# Enable the 'reduce transparency' option. Save GPU cycles.
defaults write com.apple.universalaccess reduceTransparency -bool false

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

# Show volumes
sudo chflags nohidden /Volumes

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
