#!/bin/bash

sudo apt-get install makepasswd rcs perl-doc libio-tee-perl git libmail-imapclient-perl libdigest-md5-file-perl libterm-readkey-perl libfile-copy-recursive-perl build-essential make automake libunicode-string-perl

git clone git://github.com/imapsync/imapsync.git --depth 1
cd imapsync
make

