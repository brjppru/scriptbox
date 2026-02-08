#!/bin/sh

# - Почему в космосе нет звука?
# - Потому что ракета летает под Linux

sudo sed -i 's/; default-sample-rate = 44100/default-sample-rate = 48000/g' /etc/pulse/daemon.conf
sudo sed -i 's/; avoid-resampling = false/avoid-resampling = true/g' /etc/pulse/daemon.conf
