#!/bin/sh

service fancontrol stop

e4defrag -v /root
e4defrag -v /baza
e4defrag -v /home
e4defrag -v /var/lib/transmission-daemon

service fancontrol start
