#!/bin/sh

echo "tmpfs /tmp tmpfs rw,nosuid,nodev 0 0" | sudo tee -a /etc/fstab
