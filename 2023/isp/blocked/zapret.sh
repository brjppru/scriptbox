#!/bin/sh

curl -o - https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv | sed 1d | cut -d ';' -f 3 | tr "\|" "\n" |sed 's/^[ \t]*//;s/[ \t]*$//' |uniq > zapret-urls.txt
