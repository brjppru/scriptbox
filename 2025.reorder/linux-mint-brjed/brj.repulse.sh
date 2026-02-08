#!/bin/sh

exit 0

# repulse refuck

# pactl info
# pactl list cards

# https://gist.github.com/awidegreen/6003640

#2todo sed replace
#В " _/etc/pulse/daemon.conf_ " прописать
#
#> default-sample-rate = 48000
#> avoid-resampling = yes

pulseaudio --kill

systemctl --user daemon-reload
systemctl --user enable pulseaudio.service
systemctl --user enable pulseaudio.socket
systemctl --user start pulseaudio.service
systemctl --user status pulseaudio.{service,socket}

