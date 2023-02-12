#!/bin/bash -x

# this is the brj elementary bolgenos script ;-)
# http://brj.pp.ru/
#
# bolgenos for elementaryos-0.4.1-stable.20170814.iso
# do not connect to internet and download updates

# =========================================================
# beroot
# =========================================================

beroot() {

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

}

# =========================================================
# begin up keys + ppa
# =========================================================

beroot

sudo cp -r ../add-on/etc/apt/ /etc

# =========================================================
# nuke it!
# =========================================================

sudo apt -y purge apparmor apparmor-utils noise pantheon-photos* audience evolution-data-server
sudo apt -y purge activity-log-manager-common activity-log-manager-control-center zeitgeist zeitgeist-core zeitgeist-datahub
sudo apt -y purge modemmanager appcenter
sudo apt -y purge sane pantheon-mail cups*
sudo apt -y purge switchboard-plug-parental-controls
sudo apt -y purge apport apport-gtk apport-hooks-elementary apport-symptoms elementary-os-prerelease
sudo apt -y purge dropbox*
sudo apt -y purge elementaryos-report-problem-dockitem
sudo apt -y purge evolution-data-server-google2 evolution-data-server-outlook evolution-data-server-pantheon-online-accounts
sudo apt -y purge fonts-opendyslexic gsignond gsignond-extension-pantheon gsignond-plugin-lastfm gsignond-plugin-oauth
sudo apt -y purge libgsignon-glib1 libgsignond-common0 libpantheon-online-accounts0 pantheon-online-accounts-plugin-lastfm
sudo apt -y purge python3-problem-report switchboard-plug-parental-controls libaccounts-glib0 python3-apport
sudo apt -y purge apport apport-gtk
sudo apt -y purge gnome-orca

# =========================================================
# nuked locale
# =========================================================

sudo apt -y purge language-pack*
sudo apt -y install language-pack-en language-pack-gnome-en language-pack-gnome-en-base language-pack-ru language-pack-gnome-ru language-pack-gnome-ru-base

# =========================================================
# begin up keys + ppa
# =========================================================

sudo service apparmor stop
sudo update-rc.d -f apparmor remove

# =========================================================
# preinstall needs
# =========================================================

sudo apt -y update
sudo apt -y install apt-transport-https ca-certificates figlet dpkg deborphan dconf-editor python-gpgme
sudo apt -y install software-properties-common software-properties-gtk debconf-utils
sudo apt -y install aptitude ppa-purge bzip2 gdebi synaptic gdebi dconf-editor git tig

# =========================================================
# add repos
# =========================================================
#

figlet "add repos's"

sudo add-apt-repository -y ppa:philip.scott/elementary-tweaks
sudo add-apt-repository -y ppa:ubuntuhandbook1/corebird
sudo add-apt-repository -y ppa:atareao/telegram
sudo add-apt-repository -y ppa:libreoffice/ppa
sudo add-apt-repository -y ppa:transmissionbt/ppa
sudo add-apt-repository -y ppa:linrunner/tlp
sudo add-apt-repository -y ppa:papirus/papirus
sudo apt-add-repository -y ppa:nasc-team/daily
sudo add-apt-repository -y ppa:jonathonf/backports
sudo add-apt-repository -y ppa:nilarimogard/webupd8
sudo add-apt-repository -y ppa:caffeine-developers/ppa
sudo add-apt-repository -y ppa:atareao/atareao
sudo add-apt-repository -y ppa:hluk/copyq
sudo add-apt-repository -y ppa:ubuntuhandbook1/audacity

# =========================================================
# no ppa repos
# =========================================================

echo 'deb [trusted=yes] http://www.tataranovich.com/debian xenial main' > /etc/apt/sources.list.d/tataranovich.list
echo 'deb [trusted=yes] http://archive.canonical.com/ubuntu xenial partner' > /etc/apt/sources.list.d/partner.list
echo 'deb [trusted=yes arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google-chrome.list
echo 'deb [trusted=yes] https://deb.opera.com/opera-stable/ stable non-free' > /etc/apt/sources.list.d/opera.list
echo 'deb [trusted=yes] http://build.openvpn.net/debian/openvpn/release/2.4 xenial main' > /etc/apt/sources.list.d/openvpn-aptrepo.list
echo 'deb [trusted=yes] https://download.sublimetext.com/ apt/stable/' > /etc/apt/sources.list.d/sublime-text.list

# =========================================================
# begin up keys + ppa
# =========================================================

sudo apt -y install tataranovich-keyring

# =========================================================
# sysup
# =========================================================

    figlet "keysdb"
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

# =========================================================
# begin install's
# =========================================================
#
echo opera-stable opera-stable/add-deb-source boolean false | debconf-set-selections
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
echo wireshark-common wireshark-common/install-setuid boolean true | debconf-set-selections
echo libbcg729-0	libbcg729-0/patent_compliance	boolean	true | debconf-set-selections
echo libbcg729-0:amd64	libbcg729-0/patent_compliance	boolean	true | debconf-set-selections
#

# =========================================================
# begin install's
# =========================================================

sudo apt -y install viewnior acpi arandr minicom
sudo apt -y install ristretto screenruler
sudo apt -y install nfs-common
sudo apt -y install transmission minissdpd natpmp-utils
sudo apt -y install tshark iftop sngrep ngrep sockstat
sudo apt -y install e2fslibs e2fsprogs dosfstools util-linux ntfs-3g
sudo apt -y install ntfs-config git zsh fonts-powerline
sudo apt -y install systemd-ui
sudo apt -y install nasc vim-nox
sudo apt -y install xclip xsel autocutsel copyq
sudo apt -y install network-manager-openvpn-gnome openvpn
sudo apt -y install gparted gnome-disk-utility usb-creator-gtk
sudo apt -y install freerdp rdesktop
sudo apt -y install sublime-text
sudo apt -y install sqlite3 smbclient
sudo apt -y install linphone linphone-plugin-g729
sudo apt -y install telegram
sudo apt -y install putty git shellcheck
sudo apt -y install keepassx gmrun keepass2
sudo apt -y install haveged molly-guard ncdu openssh-server htop powertop uget preload pollinate smartmontools ethtool fdupes
sudo apt -y install gnome-system-monitor caffeine netcat sshfs
sudo apt -y install tlp tlp-rdw
sudo apt -y install unace unrar zip unzip xz-utils p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract wget curl
sudo apt -y install zip unzip p7zip p7zip-rar rar unrar
sudo apt -y install mc genisoimage
sudo apt -y install giggle git gitg
sudo apt -y install ssmtp whois
sudo apt -y install git zsh fonts-powerline
sudo apt -y install aptitude cowsay curl dpkg aria2 figlet lnav
sudo apt -y install hardinfo
sudo apt -y install solaar
sudo apt -y install intel-microcode

# =========================================================
# theme's
# =========================================================
sudo apt -y install elementary-tweaks
sudo apt -y install xfonts-terminus console-terminus ttf-dejavu ttf-liberation fonts-elementary-core fonts-droid-fallback ttf-dejavu ttf-xfree86-nonfree
sudo apt -y install papirus-icon-theme libreoffice-style-papirus
sudo apt -y install elementary-wallpapers-extra comixcursors-righthanded-opaque comixcursors-righthanded

# =========================================================
# office's
# =========================================================
sudo apt -y install corebird
sudo apt -y install cups cups-pdf
sudo apt -y install gtk-redshift homebank xournal
sudo apt -y install libreoffice libreoffice-gtk libreoffice-pdfimport libreoffice-avmedia-backend-gstreamer
sudo apt -y install libreoffice-lightproof-ru-ru libreoffice-help-ru libreoffice-l10n-ru
sudo apt -y install dia graphviz xdot xdottool
sudo apt -y install thunderbird thunderbird-gnome-support

# =========================================================
# browser's
# =========================================================
sudo apt -y install google-chrome-stable chromium-browser opera-stable firefox elinks lynx
sudo apt -y install flashplugin-installer pepperflashplugin-nonfree

# =========================================================
# multimedia's
# =========================================================
sudo apt -y install audacious audacious-plugins
sudo apt -y install ubuntu-restricted-extras ffmpeg x264 libdvdread4 lame vlc browser-plugin-vlc

# =========================================================
# android tool's
# =========================================================
sudo apt -y install android-tools-adb android-tools-fastboot bluetooth libfuse-dev android-tools-adb android-tools-fsutils gphoto2 jmtpfs mtpfs

# =========================================================
# virtualbox
# =========================================================
#sudo apt -y install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils
#sudo apt -y install virt-manager netcat

# =========================================================
# game's
# =========================================================
#sudo apt -y install aisleriot gnome-cards-data pysolfc gnome-2048 dosbox gnome-mahjongg gnome-mines gnome-sudoku
# hedgewars

# =========================================================
# nuke archives
# =========================================================

rm -rf /var/cache/apt/archives
sysup

# =========================================================

notify-send -i utilities-terminal brj.done "All tasks ok successfully! ;-)"

# =========================================================
# the end
# =========================================================
#
# the end, the brj elementary bolgenos script ;-)
# http://brj.pp.ru/
#

# =========================================================
# outdated
# =========================================================

#sudo apt -y install wine zram-config
#sudo apt -y install elementary-indicator-places
#sudo apt -y install remmina remmina-plugin-rdp
#sudo apt -y install doublecmd-gtk
#sudo apt -y install vdpau-va-driver libvdpau-va-gl1 libvdpau1 vlc browser-plugin-vlc
#sudo apt -y install fluxgui
#sudo apt -y install quiterss elinks liferea
#sudo apt -y install mypaint
#sudo apt -y install pushbullet-indicator
#sudo apt -y install smartmontools ethtool qt4-qtconfig dconf-tools
#sudo apt -y install xserver-xorg-video-intel
#sudo apt -y install gtk-recordmydesktop
#sudo apt -y install audacity
#sudo apt -y install indicator-kdeconnect libqt4-svg qt5ct
#sudo apt -y install virt-manager netcat
#sudo apt -y install gnome-boxes
#sudo apt -y install btrfs-tools e2fslibs e2fsprogs dosfstools hfsutils hfsutils-tcltk f2fs-tools hfsprogs jfsutils util-linux lvm2 ntfs-3g reiser4progs reiserfsprogs xfsprogs xfsdump
#sudo apt -y install youtube-dl
#sudo apt -y install torbrowser-launcher
#sudo apt -y install easytag
#sudo apt -y install mixxx
# localepurge

#sudo add-apt-repository -y ppa:andreas-angerer89/sni-qt-patched
#sudo add-apt-repository -y ppa:varlesh-l/indicator-kdeconnect
#sudo add-apt-repository -y ppa:yunnxx/elementary
#sudo add-apt-repository -y ppa:oibaf/graphics-drivers
#sudo add-apt-repository -y ppa:atareao/pushbullet
#sudo add-apt-repository -y ppa:plushuang-tw/uget-stable
#sudo add-apt-repository -y ppa:git-core/ppa
#sudo add-apt-repository -y ppa:wireshark-dev/stable
#sudo add-apt-repository -y ppa:ricotz/docky
#sudo add-apt-repository -y ppa:varlesh-l/loki
#sudo add-apt-repository -y ppa:ubuntu-wine/ppa
#sudo add-apt-repository -y ppa:ubuntuhandbook1/apps
#sudo add-apt-repository -y ppa:quiterss/quiterss
#sudo add-apt-repository -y ppa:webupd8team/sublime-text-2
#sudo add-apt-repository -y ppa:videolan/stable-daily
#sudo add-apt-repository -y ppa:linphone/release
#sudo add-apt-repository -y ppa:mixxx/mixxx
