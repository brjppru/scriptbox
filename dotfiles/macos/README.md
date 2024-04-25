# brj@macos X configuration

## zverdvd edition

- EOL + EOS on macos -> https://endoflife.date/macos
- hot keys -> https://support.apple.com/en-us/HT201236

## Клавиатура

 - Хоткеи: ⇧ = Shift, ⌃ = Control, ⌘ = Command, ⌥ = Option / Alt.
 - Shift-Command-G: Open a Go to Folder window.

##  mail.app

- для перемешения почты по favorites папкам Control-Command-2

### boot flash / reinstall

```
brjed@air ~ % sudo /Applications/Install\ macOS\ Monterey.app/Contents/Resources/createinstallmedia --volume /volumes/macos12
```

### hostname

```
sudo scutil --set HostName
```

## my hardware

 - MacBook Air (M1, 2020 г.) - 16G/1tb -> Спецификации -> 13,3-inch (2560 × 1600) -> https://support.apple.com/kb/SP825?locale=ru_RU

## Как переустановить ОС macOS? 

Используйте возможности восстановления macOS для переустановки операционной системы Mac. -> Процессор Apple -> Нажмите кнопку питания, чтобы включить компьютер Mac, и продолжайте удерживать ее нажатой, пока не отобразится окно с параметрами запуска. Нажмите значок в виде шестеренки (меню «Параметры»), затем нажмите «Продолжить».

## root

```
dsenableroot
```

## sudo

Use touchid for sudo

```
here is
```

## dock space

```
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'; killall Dock
```

## daily driver

- cyberduck
- virtual dj
- vlc
- kitty (see addons)
- Rectangle
- numi
- https://sponsor.ajay.app
- pasta (appstore)
- sublime-text
- audacity
- cron.app
- kepassxc
- telephone 

## brew

- ncdu
- mtr
- fdupes
- duf
- htop
- ipcalc
- sevenzi
- rar
- syncthing
- font-jetbrains-mono (pached)
- helix
- htop
- midnight-commander

## brew cascs 

- android-platform-tools
- arc
- cloudflare-warp
- coconutbattery
- imazing
- keepassxc
- kitty
- localsend
- numi
- rar
- rectangle
- remote-desktop-manager
- sublime-text
- telegram-desktop
- termius
- thunderbird (for calendar printing)
- vlc

## localsend

- brew tap localsend/localsend
- brew install localsend

## ioquake3 files

-  ~/Library/Application Support/Quake3/baseq3/

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

## no brew, static binares
  - ffprobe release as zip: https://evermeet.cx/ffmpeg/getrelease/ffprobe/zip
  - ffmpeg release as zip: https://evermeet.cx/ffmpeg/getrelease/zip
  - https://github.com/yt-dlp/yt-dlp/releases
