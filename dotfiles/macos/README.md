# brj@macos configuration

macos zverdvd 2025 edition(tm)

# EOL + EOS

- EOL + EOS on macos -> https://endoflife.date/macos
- hot keys -> https://support.apple.com/en-us/HT201236

## Клавиатура

 - Хоткеи: ⇧ = Shift, ⌃ = Control, ⌘ = Command, ⌥ = Option / Alt.
 - Shift-Command-G: Open a Go to Folder window.

## my hardware

 - MacBook Air (M1, 2020) -> 16G/1tb -> 13,3" -> (2560 × 1600) -> https://support.apple.com/ru-ru/111883
 - MacBook Pro (M1 Pro, 2021) -> 16G/512G -> 16,1" -> (3456×2234) -> https://support.apple.com/ru-ru/111901

## Как переустановить ОС macOS?

Используйте возможности восстановления macOS для переустановки операционной системы Mac. -> Процессор Apple -> Нажмите кнопку питания, чтобы включить компьютер Mac, и продолжайте удерживать ее нажатой, пока не отобразится окно с параметрами запуска. Нажмите значок в виде шестеренки (меню «Параметры»), затем нажмите «Продолжить».

## boot flash / reinstall

  - installer docs -> https://support.apple.com/en-us/101578

```
softwareupdate --list-full-installers
softwareupdate --fetch-full-installer --full-installer-version 15.0
```

```
brjed@air ~ % sudo /Applications/Install\ macOS\ Monterey.app/Contents/Resources/createinstallmedia --volume /volumes/macos15
```

###  mail.app

- для перемешения почты по favorites папкам Control-Command-2

### hostname

```
sudo scutil --set HostName
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

```
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'; killall Dock
```

## stack's

  - https://www.bluestacks.com/mac
  - https://orbstack.dev/

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
- cron.app
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
- zbar
- yazi
- hugo
- htop
- ipcalc
- sevenzip
- rar unrar
- htop
- ffmpeg
- midnight-commander


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

## payed

- https://mixedinkey.com/platinum-notes/
- microsoft office
- forklift

## mas

https://github.com/mas-cli/mas -> 📦 Mac App Store command line interface

```
brew install mas
mas signin icloud@icloud.com
mas search pasta
mas intall 1438389787
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

xattr -cr removes extended attributes (like quarantine flags) from the app to fix "damaged" errors.
codesign --force --deep --sign - re-signs the app locally to resolve macOS signature issues.
It's for fixing untrusted or non-Store apps.

```
/Applications/thebrj.app && codesign --force --deep --sign - /Applications/thebrj.app
```

### chattr

chflags uchg file or nouchg -> Prevents changes to the file's contents or metadata. This is similar to the i attribute in chattr.

## ioquake3 files

```~/Library/Application Support/Quake3/baseq3/```

## zsh

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

## no brew, static binares for intel
  - ffprobe release as zip -> https://evermeet.cx/ffmpeg/getrelease/ffprobe/zip
  - ffmpeg release as zip -> https://evermeet.cx/ffmpeg/getrelease/zip
  - yt-dlp -> https://github.com/yt-dlp/yt-dlp/releases
