#!/bin/sh

mimetype () {
	NAME=`echo $1 | /usr/bin/tr '[:upper:]' '[:lower:]'`
	case "$NAME" in
		*.gif)	MIMETYPE="image/gif";;
		*.html)	MIMETYPE="text/html";;
		*.jpg)	MIMETYPE="image/jpeg";;
		*.png)	MIMETYPE="image/png";;
		*)		MIMETYPE="text/plain";;
	esac
}

basedir () {
	HOST=`echo $1 | /usr/bin/sed 's/^http:\/\///'`
	HOST=`echo $HOST | /usr/bin/sed 's/\/.*$//'`
	HOST=`echo $HOST | /usr/bin/sed 's/:.*$//'`
	case "$HOST" in
#		*.meow.org.uk)	BASEDIR="/home/andreww/public_html/";;
		*)				BASEDIR="/var/apache/htdocs/";;
	esac
}

filename() {
	FILENAME=`echo $URI | /usr/bin/sed 's/^http:\/\///'`
	FILENAME=`echo $FILENAME | /usr/bin/sed s/\^$HOST//`
	case "$FILENAME" in
		*/) FILENAME=`echo $FILENAME | /usr/bin/sed 's/$/\/index.html/'`;;
	esac
}

URI=""
REQ="n"
EXIT="n"
INPLINE="some arbitrary random value"
while [ "$EXIT" = "n" ] ; do
	read INPLINE
	INPLINE=`echo $INPLINE | sed 's/$//'`
	echo $INPLINE >> /var/tmp/httpd.out
	INPLINE=`echo $INPLINE | /usr/bin/sed 's/^ *//'`
	if [ -z "$INPLINE" ] && [ "$REQ" = "y" ] ; then
		EXIT="y"
	fi
	COMMAND=`echo $INPLINE | /usr/bin/cut -d" " -f1`
	case "$COMMAND" in
		GET|HEAD)	REQ="y"
					METHOD=$COMMAND
					URI=`echo $INPLINE | /usr/bin/cut -d" " -f2`;;
	esac
done

case "$URI" in
	http://*)	;;
	*)			URI=`echo $URI | /usr/bin/sed 's/^/http:\/\/www.meow.org.uk\//'`;;
esac

basedir "$URI"
filename "$URI"
mimetype "$FILENAME" 

RESPONSE="200"
if [ ! -r "$BASEDIR/$FILENAME" ] ; then
	RESPONSE="404"
	MIMETYPE="text/html"
fi
echo "HTTP/1.0 $RESPONSE Oh well"
echo "Server: httpd-sh andrew wales"
echo "Content-type: $MIMETYPE"
if [ "$METHOD" = "GET" ] ; then
	echo
	case "$RESPONSE" in
		200)	/usr/bin/cat $BASEDIR/$FILENAME;;
		404)	echo "oops, file not found";;
		*)		echo "broken behaviour.  imagine";;
	esac
fi

# vim:ts=4
