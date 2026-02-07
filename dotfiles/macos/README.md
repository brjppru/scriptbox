# brj@macos configuration

brj@macos zverdvd 2025 edition(tm) -> There are some things in life that just can't be automated... or aren't 100% worth the time ;-(

This document covers that, at least in terms of setting up a brand new Mac out of the box.

## Preflight & References

### My Hardware

- MacBook Air (M1, 2020) -> 16G/1tb -> 13,3" -> (2560 × 1600) -> https://support.apple.com/ru-ru/111883
- MacBook Pro (M1 Pro, 2021) -> 16G/512G -> 16,1" -> (3456×2234) -> https://support.apple.com/ru-ru/111901
- MacBook Pro (M3 Pro, Nov 2023) -> 36G/512G -> 16,1" -> (3456x2234) -> https://support.apple.com/ru-ru/117737
- MacBook Air (M4, 2025) -> 16G/256G -> 13,6" -> (2560x1664) -> https://support.apple.com/en-us/122209

### EOL + EOS

- EOL + EOS on macos -> https://endoflife.date/macos
- Hot keys -> https://support.apple.com/en-us/HT201236

### Keyboard Shortcuts

- Hotkeys: ⇧ = Shift, ⌃ = Control, ⌘ = Command, ⌥ = Option / Alt
- Shift-Command-G: Open a Go to Folder window

- Telegramm -> https://github.com/telegramdesktop/tdesktop/wiki/Keyboard-Shortcuts
- macOS shortcuts -> [hotkeys/macos-shortcuts.md](hotkeys/macos-shortcuts.md)
- VSCode shortcuts (macOS) -> [hotkeys/vscode-shortcuts-macos.md](hotkeys/vscode-shortcuts-macos.md)

## Initial Setup

### Naming controls

Open the MacBook you want to rename in apple account, then go to Applo > System Settings > General > About, and change the Name field.
Set it to something clear, for example “Air Kitchen” and “Air Work”, wait a couple of minutes, then open Apple Account again.
The devices list usually does not update immediately.
For other use:

```
sudo scutil --set ComputerName "0xDEADBEEF"
sudo scutil --set HostName "0xDEADBEEF"
sudo scutil --set LocalHostName "0xDEADBEEF"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0xDEADBEEF"
```


### Basic Setup Steps

- Sign in to App Store (since mas can't sign in automatically)
- Clone this repo, run `.osx`
- Start Synchronization tasks
- Configure Time Machine backup drive
- Install Wireguard VPN configurations (if needed)
- Install viscosity (Mac OpenVPN client) (if needed)

## Access & Security

### Remote Login Setup

On the Mac you want to connect to: Go to System Preferences > Sharing -> Enable 'Remote Login' -> You can also enable remote login on the command line:

```bash
sudo systemsetup -setremotelogin on
```


### Enable Root and Sudo

Enable root user:

```bash
dsenableroot
```

Use TouchID for sudo:

```bash
sudo su root -c 'chmod +w /etc/pam.d/sudo && echo "auth       sufficient     pam_tid.so\n$(cat /etc/pam.d/sudo)" > /etc/pam.d/sudo && chmod -w /etc/pam.d/sudo'
```

### File Attributes and App Signing

#### Special Installations
```bash
brew install alienator88/homebrew-cask/sentinel-app
```

#### Resign Apps and Remove Attributes

xattr -cr removes extended attributes (like quarantine flags) from the app to fix "damaged" errors. codesign --force --deep --sign - re-signs the app locally to resolve macOS signature issues. It's for fixing untrusted or non-Store apps.

```bash
/Applications/thebrj.app && codesign --force --deep --sign - /Applications/thebrj.app
```

or

```bash
Game="/Applications/xmind.app"
sudo xattr -c -r "$Game"
sudo xattr -r -d com.apple.quarantine "$Game"
sudo xattr -cr "$Game"
sudo xattr -rd com.apple.quarantine "$Game"
chmod +x "$Game"
```

#### File Attributes (chattr)

chflags uchg file or nouchg -> Prevents changes to the file's contents or metadata. This is similar to the i attribute in chattr.

## Power & Sleep

### PowerHour(tm)

#### Sleeping

https://support.apple.com/en-us/120622

A Mac laptop with Apple silicon automatically turns on and starts up when you open its lid or connect it to power. With macOS Sequoia 15 or later, you can change this behavior without affecting your ability to use your keyboard or trackpad to turn on your Mac.

Make sure that your Mac laptop with Apple silicon is using macOS Sequoia or later.

Open the Terminal app, which is in the Utilities folder of your Applications folder.

Type one of these commands in Terminal, then press Return:

To prevent startup when opening the lid or connecting to power:

```bash
sudo nvram BootPreference=%00
```

To prevent startup only when opening the lid:

```bash
sudo nvram BootPreference=%01
```

To prevent startup only when connecting to power:

```bash
sudo nvram BootPreference=%02
```

Type your administrator password when prompted (Terminal doesn't show the password as it's typed), then press Return.

To undo any of the previous commands and reenable automatic startup when opening the lid or connecting to power, enter:

```bash
sudo nvram -d BootPreference
```

#### DeepSleep

Got into the classic trap: close the MacBook at night, and in the morning it won't wake up without a charger. Macs these days just ain't what they used to be. In fact, I've got a ton of terminals, remote desktops and other toys that the Mac kindly remembers and wakes itself up for, all night long.

The trick is dead simple.
First, ask the Mac how often it wakes up:

```bash
pmset -g log | grep due
```

When you see it wakes up almost every minute, just tell it to stop keeping connections alive:

```bash
sudo pmset -b tcpkeepalive 0
```

Result: the Mac survives the night losing only 1-2% battery. Downside: all connections drop, so after opening the lid you wait about a minute for the world to come back.

## Interface Tweaks

### Dock Customization

#### Add Dock Spacers

Regular spacer script:

```bash
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'; killall Dock
```

Small spacer script:

```bash
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'; killall Dock
```

Move the spacer? Drag and drop the spacer to the desired location on your dock. You can delete spacers like any other icon on your dock. Drag the icon off your dock to remove it from your dock or right-click and choose Remove from Dock.

## Backup & Recovery

### macOS Reinstall

Use macOS recovery options to reinstall the Mac operating system. -> Apple Processor -> Press the power button to turn on your Mac, and continue holding it until the startup options window appears. Click the gear icon (Options menu), then click Continue.

### Boot Flash / Reinstall

```bash
softwareupdate --list-full-installers; echo; echo "Please enter version number you wish to download:"; read REPLY; [ -n "$REPLY" ] && softwareupdate --fetch-full-installer --full-installer-version "$REPLY"
```

To create an installation USB drive, you need a USB drive of at least sixteen gigabytes. It needs to be formatted in Mac OS Extended Journaled file system with GUID partition table.

Open Disk Utility. In the View menu, select Show All Devices. Select the USB drive and click Erase. In the Name field, specify a name like MyUSB. In the Format field, select Mac OS Extended Journaled. In the Scheme field, select GUID Partition Map. Confirm deletion.

By default, Disk Utility only shows partitions -> press Cmd/Win+2 to show all devices (alternatively you can press the View button)

- installer docs -> https://support.apple.com/en-us/101578

```bash
softwareupdate --list-full-installers
softwareupdate --fetch-full-installer --full-installer-version 15.0
```

```bash
sudo /Applications/Install\ macOS\ Sequoia.app/Contents/Resources/createinstallmedia --volume /volumes/macos15 
```

### Erase Old Mac

Erase your Mac and reset it to factory settings -> https://support.apple.com/en-au/102664

## Package Management

### Homebrew Setup

#### Check Installed Packages

```bash
brew deps --tree --installed
brew leaves | xargs brew desc --eval-all
```

```bash
brew list --formula | \
    xargs -n1 -P8 -I {} \
    sh -c "
        brew info {} | \
        egrep '[0-9]* files, ' | \
        sed 's/^.*[0-9]* files, \(.*\)).*$/{} \1/'
    " | \
    sort -h -r -k2 - | \
    column -t
```

#### Non-Brew App Store Apps

```bash
find /Applications -path '*Contents/_MASReceipt/receipt' -maxdepth 4 -print |\sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'
```

### Homebrew Packages (formulas)

#### System Tools
- ncdu
- tmux
- htop
- midnight-commander
- duf
- tig
- yazi
- fdupes
- lazygit
- gitup-app

#### Network Tools
- mtr
- trippy
- sipcalc
- connectmenow

#### Media Tools
- ffmpeg
- yt-dlp
- zbar
- sevenzip
- rar unrar

#### Development Tools
- hugo
- tablecruncher

#### Other Tools
- scrcpy
- android-platform-tools

### Homebrew Casks

```bash
brew install --cask --no-quarantine
```

#### Development Tools
- sublime-text
- kitty
- remote-desktop-manager
- windows app

#### Utilities
- forklift
- appcleaner
- keepassxc
- rectangle
- macs-fan-control
- betterdisplay
- applite
- pearcleaner
- macwhisper
- monitorcontrol
- flameshot
- losslesscut
- glow

#### Media Applications
- brave-browser
- audacity
- blackhole-2ch
- butt
- vlc
- thunderbird (for calendar printing)
- telegram-desktop
- kid3

#### System Tools
- coconutbattery
- imazing
- numi
- rar
- jordanbaird-ice
- fliqlo
- runcat

### Mac App Store (mas)

https://github.com/mas-cli/mas -> 📦 Mac App Store command line interface

```bash
brew install mas
mas signin icloud@icloud.com
mas search pasta
mas install 1438389787
```

## Applications Setup

### Daily Drivers

- cyberduck
- virtual dj
- vlc
- kitty (see addons)
- rectangle
- numi
- https://sponsor.ajay.app
- ~~pasta (appstore)~~ -> hammerspoon
- sublime-text
- audacity
- notion-calendar
- kepassxc
- telephone

### Hammerspoon

Makes a sound when something is copied to clipboard. Lives in ~/.hammerspoon.

### Syncthing

Install flat, not casc, http://localhost:8384/

Config for Syncthing live in $HOME/Library/Application Support/Syncthing

```bash
brew services stop syncthing
pgrep syncthing
brew services start syncthing
```

### Brave Browser

No access to local network sites? Go to "Local Network" setting in macOS Privacy settings and enable it.

#### Plugins

- Imagus mod -> https://www.reddit.com/r/imagus/
- SingleFile -> https://github.com/gildas-lormeau/SingleFile
- Enhancer for YouTube™
- SponsorBlock for YouTube
- RSS Hub radar -> https://github.com/DIYgod/RSSHub-Radar

### Other Applications

#### Mail.app

To move mail to favorites folders Control-Command-2

#### Wine

```bash
softwareupdate --install-rosetta --agree-to-license
brew install --cask --no-quarantine wine-stable
brew install --no-quarantine winetricks
```

#### JetBrains Mono Font

- JetBrainsMono -> https://www.nerdfonts.com/font-downloads
- download -> https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip
- copy to `/Users/brjed/Library/Fonts/`
- or `brew install --no-quarantine --cask font-jetbrains-mono-nerd-font`

#### Virtualization

- https://www.bluestacks.com/mac
- https://orbstack.dev/
- https://github.com/insidegui/VirtualBuddy

#### Network UPS Tools

- https://nutty.pingie.com/ -> network ups tools

## Developer Tools

### Zsh Setup

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Zsh Plugins

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

```bash
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $ZSH_CUSTOM/plugins/autoupdate
```

```bash
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
 ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
```

## Maintenance & Troubleshooting

### Disk Operations (dd)

```bash
diskutil list
sudo diskutil unmountDisk disk4
xzcat file.img.xz | sudo dd of=/dev/rdisk4 bs=1m
sudo sync
```

### Startup Fixes

You likely have an extremely tiny file in /Library/LaunchAgents or /Library/LaunchDeamons that would launch someshit the background if required. Obviously it cant work now since you removed it but the tiny file is still present -> Open Finder -> Under locations select your macbook/macintosh HD/library/LaunchAgents AND also check LaunchDaemons

### ioquake3 Files

```text
~/Library/Application Support/Quake3/baseq3/
```

## Paid Software

- https://mixedinkey.com/platinum-notes/
- microsoft office
- forklift
