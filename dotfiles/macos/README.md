# brj@macos configuration

brj@macos zverdvd 2025 edition(tm) -> There are some things in life that just can't be automated... or aren't 100% worth the time ;-(

This document covers that, at least in terms of setting up a brand new Mac out of the box.

  - Sign in to App Store (since mas can't sign in automatically)
  - Clone this repo, run ```.osx```
  - Start Synchronization tasks
  - Configure Time Machine backup drive
  - Install Wireguard VPN configurations (if needed)
  - Install viscosity (Mac OpenVPN client) (if needed)
  - On the Mac you want to connect to: Go to System Preferences > Sharing -> Enable 'Remote Login' -> You can also enable remote login on the command line: ```sudo systemsetup -setremotelogin on```

# EOL + EOS

- EOL + EOS on macos -> https://endoflife.date/macos
- hot keys -> https://support.apple.com/en-us/HT201236

## Клавиатура

 - Хоткеи: ⇧ = Shift, ⌃ = Control, ⌘ = Command, ⌥ = Option / Alt.
 - Shift-Command-G: Open a Go to Folder window.

## my hardware

 - MacBook Air (M1, 2020) -> 16G/1tb -> 13,3" -> (2560 × 1600) -> https://support.apple.com/ru-ru/111883
 - MacBook Pro (M1 Pro, 2021) -> 16G/512G -> 16,1" -> (3456×2234) -> https://support.apple.com/ru-ru/111901
 - MacBook Pro (M3 Pro, Nov 2023) -> 36G/512G -> 16,1" -> (3456x2234) -> https://support.apple.com/ru-ru/117737

# PowerHour(tm)

## Sleeping

https://support.apple.com/en-us/120622

A Mac laptop with Apple silicon automatically turns on and starts up when you open its lid or connect it to power. With macOS Sequoia 15 or later, you can change this behavior without affecting your ability to use your keyboard or trackpad to turn on your Mac.

Make sure that your Mac laptop with Apple silicon is using macOS Sequoia or later.

Open the Terminal app, which is in the Utilities folder of your Applications folder.

Type one of these commands in Terminal, then press Return:

To prevent startup when opening the lid or connecting to power: ```sudo nvram BootPreference=%00```

To prevent startup only when opening the lid: ```sudo nvram BootPreference=%01```

To prevent startup only when connecting to power: ```sudo nvram BootPreference=%02```

Type your administrator password when prompted (Terminal doesn’t show the password as it's typed), then press Return.

To undo any of the previous commands and reenable automatic startup when opening the lid or connecting to power, enter ```sudo nvram -d BootPreference``` in Terminal.

## DeepSleep

Got into the classic trap: close the MacBook at night, and in the morning it plays diva — refuses to wake up without a charger. Macs these days just ain’t what they used to be. In fact, I’ve got a ton of terminals, remote desktops and other toys that the Mac kindly remembers and wakes itself up for, all night long.

The trick is dead simple.
First, ask the Mac how often it twitches:
```pmset -g log | grep due```
When you see it wakes up almost every minute, just tell it to stop keeping connections alive:
```sudo pmset -b tcpkeepalive 0```

Result: the Mac survives the night losing only 1-2% battery. Downside: all connections drop, so after opening the lid you wait about a minute for the world to come back.

## MacOS reinstall

Используйте возможности восстановления macOS для переустановки операционной системы Mac. -> Процессор Apple -> Нажмите кнопку питания, чтобы включить компьютер Mac, и продолжайте удерживать ее нажатой, пока не отобразится окно с параметрами запуска. Нажмите значок в виде шестеренки (меню «Параметры»), затем нажмите «Продолжить».

## boot flash / reinstall

```
softwareupdate --list-full-installers; echo; echo "Please enter version number you wish to download:"; read REPLY; [ -n "$REPLY" ] && softwareupdate --fetch-full-installer --full-installer-version "$REPLY"
```

Для создания установочной флешки нужен USB накопитель не меньше шестнадцати гигабайт. Его нужно отформатировать в файловую систему Mac OS Extended Journaled c таблицей разделов GUID.

Открыть Disk Utility. В меню View выбрать Show All Devices. Выбрать флешку и нажать Erase. В поле Name указать название например MyUSB. В поле Format выбрать Mac OS Extended Journaled. В поле Scheme выбрать GUID Partition Map. Подтвердить удаление.

By default, Disk Utility only shows partitions -> press Cmd/Win+2 to show all devices (alternatively you can press the View button)

  - installer docs -> https://support.apple.com/en-us/101578

```
softwareupdate --list-full-installers
softwareupdate --fetch-full-installer --full-installer-version 15.0
```

```
$ sudo /Applications/Install\ macOS\ Sequoia.app/Contents/Resources/createinstallmedia --volume /volumes/macos15 
Ready to start.
To continue we need to erase the volume at /volumes/macos15.
If you wish to continue type (Y) then press return: y
Erasing disk: 0%... 10%... 20%... 30%... 100%
Copying essential files...
Copying the macOS RecoveryOS...
Making disk bootable...
Copying to disk: 0%... 10%... 20%... 30%... 40%... 50%... 60%... 70%... 80%... 100%
Install media now available at "/Volumes/Install macOS Sequoia"
```

###  mail.app

- для перемешения почты по favorites папкам Control-Command-2

### hostname

```
FDQN	
sudo scutil --set HostName pro05.l0.brj.kz

Bonjour hostname	
sudo scutil --set LocalHostName pro05

computer name	
sudo scutil --set ComputerName pro05.l0.brj.kz
```

## root

```
dsenableroot
```

## sudo

Use touchid for sudo

```
sudo su root -c 'chmod +w /etc/pam.d/sudo && echo "auth       sufficient     pam_tid.so\n$(cat /etc/pam.d/sudo)" > /etc/pam.d/sudo && chmod -w /etc/pam.d/sudo'
```
## add dock space

Regular spacer script:

```
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'; killall Dock
```
Small spacer script:

```
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'; killall Dock
```

Move the spacer? Drag and drop the spacer to the desired location on your dock. You can delete spacers like any other icon on your dock. Drag the icon off your dock to remove it from your dock or right-click and choose Remove from Dock.

## stack's

  - https://www.bluestacks.com/mac
  - https://orbstack.dev/
  - https://github.com/insidegui/VirtualBuddy

## brew

non brew, but installed from app store

```
find /Applications -path '*Contents/_MASReceipt/receipt' -maxdepth 4 -print |\sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'
```

```
Windows App.app
iMovie.app
Mollama.app
TCAminesweeper.app
Pasta.app
Disk Graph.app
Receiver Radio.app
```


```
brew deps --tree --installed
brew leaves | xargs brew desc --eval-all
```

```
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

### syncthing

install flat, not casc, http://localhost:8384/

config for Syncthing live in $HOME/Library/Application Support/Syncthing

```
brew services stop syncthing
pgrep syncthing
brew services start syncthing
```

### JetBrainsMono

  - JetBrainsMono -> https://www.nerdfonts.com/font-downloads
  - download -> https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip
  - copy to ```/Users/brjed/Library/Fonts/```
  - or ```brew install --no-quarantine --cask font-jetbrains-mono-nerd-font```

### daily driver

- cyberduck
- virtual dj
- vlc
- kitty (see addons)
- rectangle
- numi
- https://sponsor.ajay.app
- pasta (appstore)
- sublime-text
- audacity
- notion-calendar
- kepassxc
- telephone 

## brew packages

- ncdu
- zbar
- yt-dlp
- trippy
- mtr
- fdupes
- tmux
- scrcpy
- midnight-commander
- duf
- tig
- yazi
- hugo
- htop
- sipcalc
- sevenzip
- rar unrar
- htop
- ffmpeg
- midnight-commander
- connectmenow
- tablecruncher

## brew install --cask 

```brew install --cask --no-quarantine ```

- android-platform-tools
- forklift
- fbreader
- appcleaner
- brave
- audacity
- blackhole-2ch
- butt
- coconutbattery
- imazing
- keepassxc
- kitty
- numi
- rar
- rectangle
- remote-desktop-manager
- windows app
- sublime-text
- telegram-desktop
- thunderbird (for calendar printing)
- vlc
- macs-fan-control
- betterdisplay
- jordanbaird-ice
- applite
- pearcleaner
- macwhisper
- fliqlo
- kid3
- monitorcontrol
- flameshot
- losslesscut

- brew install alienator88/homebrew-cask/sentinel-app


## payed

- https://mixedinkey.com/platinum-notes/
- microsoft office
- forklift

## nut

- https://nutty.pingie.com/ -> network ups tools

## mas

https://github.com/mas-cli/mas -> 📦 Mac App Store command line interface

```
brew install mas
mas signin icloud@icloud.com
mas search pasta
mas install 1438389787
```

```
mas install 1438389787
==> Downloading Pasta - Clipboard Manager (1.4.10)
==> Downloaded Pasta - Clipboard Manager (1.4.10)
==> Installing Pasta - Clipboard Manager (1.4.10)
==> Installed Pasta - Clipboard Manager (1.4.10)
```

## wined

```
softwareupdate --install-rosetta --agree-to-license
brew install --cask --no-quarantine wine-stable
brew install --no-quarantine winetricks
```

## brave

No access to local network sites? Go to “Local Network” setting in macOS Privacy settings and enable it.

### plugins

  - Imagus mod
  - SingleFile
  - Enhancer for YouTube™
  - SponsorBlock for YouTube
  - RSS Subscription Extension, Reader

## resign the app and attr

xattr -cr removes extended attributes (like quarantine flags) from the app to fix "damaged" errors. codesign --force --deep --sign - re-signs the app locally to resolve macOS signature issues. It's for fixing untrusted or non-Store apps.

```
/Applications/thebrj.app && codesign --force --deep --sign - /Applications/thebrj.app
```

or

```
Game="/Applications/xmind.app"
sudo xattr -c -r "$Game"
sudo xattr -r -d com.apple.quarantine "$Game"
sudo xattr -cr "$Game"
sudo xattr -rd com.apple.quarantine "$Game"
chmod +x "$Game"
```

or 

- brew install alienator88/homebrew-cask/sentinel-app

### chattr

chflags uchg file or nouchg -> Prevents changes to the file's contents or metadata. This is similar to the i attribute in chattr.

## ioquake3 files

```~/Library/Application Support/Quake3/baseq3/```

## zsh

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

```
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $ZSH_CUSTOM/plugins/autoupdate
```

```
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
 ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
```

## dd

```
diskutil list
sudo diskutil unmountDisk disk4
xzcat file.img.xz | sudo dd of=/dev/rdisk4 bs=1m
sudo sync
```

## startup fixes

You likely have an extremely tiny file in /Library/LaunchAgents or /Library/LaunchDeamons that would launch someshit the background if required. Obviously it cant work now since you removed it but the tiny file is still present -> Open Finder -> Under locations select your macbook/macintosh HD/library/LaunchAgents AND also check LaunchDaemons


## erase old mac

Erase your Mac and reset it to factory settings -> https://support.apple.com/en-au/102664

## no brew, static binares for intel
  - ffprobe release as zip -> https://evermeet.cx/ffmpeg/getrelease/ffprobe/zip
  - ffmpeg release as zip -> https://evermeet.cx/ffmpeg/getrelease/zip
  - yt-dlp -> https://github.com/yt-dlp/yt-dlp/releases
