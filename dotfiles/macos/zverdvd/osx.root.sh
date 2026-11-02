#!/usr/bin/env bash

# brj@.macos X configuration - ROOT LEVEL SETTINGS
# This script contains macOS settings that require root privileges

# 2025.10.17 first fork ()
# 2025.12.22 refactor
# 2026.01.18 tahoe updates fix

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

# Keeps macOS 15.7.x and security updates enabled while preventing installation and intrusive prompts for the major upgrade to Tahoe

defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool false
defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool false

# Restart automatically if the computer freezes
systemsetup -setrestartfreeze on

###############################################################################
# Power & battery                                                             #
###############################################################################

# Captured from air13m4w (MacBook Air M4, macOS 15.8.2) on 2026.11.02.
# -b battery, -c charger, -a both. Not listed here = macOS default
# (standby 1, hibernatemode 3, tcpkeepalive 1, womp: charger 1 / battery 0).

# Do not dim the display on battery ("Slightly dim the display on battery" off)
pmset -b lessbright 0
# Do not sleep on the charger when the display is off (downloads and ssh keep running)
pmset -c sleep 0
# Turn the display off after 5 minutes on battery and on the charger
pmset -a displaysleep 5
# Power Nap on battery too, not only on the charger
pmset -b powernap 1

# Optimized Battery Charging (holds at 80% and tops off before unplug) is on.
# It is a System Settings toggle with no supported pmset/defaults key, so it is not set here.
# macOS 15 has no manual charge limit (smartcharging ManualChargeLimit 0); use AlDente for a hard 80% cap.

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Exclude from Spotlight: mounted volumes, ~/Library/Application Support, ~/Library/Caches
# (app data there made mds_stores write ~5 GB/h on air13m4w, 2026.10.18)
# and ~/clms (ticket snapshots, ~30k JSON files rewritten every few days, 2026.10.31).
# Dot-folders (~/.claude, ~/.codex) are not indexed by Spotlight anyway.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
# Exclusions live on the Data volume, /.Spotlight-V100 does not exist on modern macOS.
# Entries are appended, existing ones are kept (-array would wipe the list).
SPOTLIGHT_PLIST="/System/Volumes/Data/.Spotlight-V100/VolumeConfiguration.plist"
USER_HOME=$(dscl . -read "/Users/${SUDO_USER:-$(id -un)}" NFSHomeDirectory | cut -d' ' -f2)
/usr/libexec/PlistBuddy -c "Print :Exclusions" "$SPOTLIGHT_PLIST" >/dev/null 2>&1 \
  || /usr/libexec/PlistBuddy -c "Add :Exclusions array" "$SPOTLIGHT_PLIST"
for dir in "/Volumes" "$USER_HOME/Library/Application Support" "$USER_HOME/Library/Caches" "$USER_HOME/clms"; do
  if ! /usr/libexec/PlistBuddy -c "Print :Exclusions" "$SPOTLIGHT_PLIST" | grep -qxF "    $dir"; then
    /usr/libexec/PlistBuddy -c "Add :Exclusions: string $dir" "$SPOTLIGHT_PLIST"
  fi
done

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
