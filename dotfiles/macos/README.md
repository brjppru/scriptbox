# brj@macos configuration

## zverdvd edition

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
    column -t```
```

### syncthing

install flat, not casc, http://localhost:8384/

```
brew services stop syncthing
pgrep syncthing
brew services start syncthing
```

### JetBrainsMono

  - JetBrainsMono -> https://www.nerdfonts.com/font-downloads
  - download -> https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
  - copy to ```/Users/brjed/Library/Fonts/```

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
- mtr
- fdupes
- duf
- tig
- zbar
- yazi
- hugo
- htop
- ipcalc
- sevenzip
- rar
- htop
- midnight-commander

## brew install --cask 

```brew install --cask --no-quarantine ```

- android-platform-tools
- forklift
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

## brave

No access to local network sites? Go to “Local Network” setting in macOS Privacy settings and enable it.

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

## startup fixes

You likely have an extremely tiny file in /Library/LaunchAgents or /Library/LaunchDeamons that would launch someshit the background if required. Obviously it cant work now since you removed it but the tiny file is still present -> Open Finder -> Under locations select your macbook/macintosh HD/library/LaunchAgents AND also check LaunchDaemons

## no brew, static binares for intel
  - ffprobe release as zip -> https://evermeet.cx/ffmpeg/getrelease/ffprobe/zip
  - ffmpeg release as zip -> https://evermeet.cx/ffmpeg/getrelease/zip
  - yt-dlp -> https://github.com/yt-dlp/yt-dlp/releases
