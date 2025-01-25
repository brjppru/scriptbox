#!/bin/sh

docker network create -d macvlan --subnet=192.168.88.0/24 --gateway=192.168.88.1 -o parent=enp3s0 net88


