#!/bin/sh
echo $1:$(doveadm pw -s ssha512 -p $2)::::::
# >> /etc/dovecot/users
