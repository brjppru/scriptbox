#!/bin/sh

# rainloop #

mkdir -p /docker/rainloop
docker pull hardware/rainloop
docker stop rainloop
docker rm rainloop

docker run -d \
    --name rainloop \
    -v "/docker/rainloop:/rainloop/data" \
    -p 8888:8888 \
    --restart=unless-stopped \
    hardware/rainloop

exit 0

https://hub.docker.com/r/hardware/rainloop/
https://github.com/hardware/mailserver/wiki/Rainloop-initial-configuration

To configure rainloop, use admin panel found at : https://webmail.domain.tld/?admin

:bulb: Don't forget to add a new A/CNAME record in your DNS zone.

Default login is "admin", password is "12345".
