#!/bin/sh

rm -rf /usr/src
rm -rf /usr/ports
svn checkout https://svn0.ru.FreeBSD.org/ports/head /usr/ports
svn checkout https://svn0.ru.freebsd.org/base/stable/9 /usr/src

