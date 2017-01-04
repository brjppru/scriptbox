#!/bin/sh

log="logfile"

#
# Check out a fresh copy of press.xml from /www/en
#
echo ""
echo "==> Checking out fresh copy of press.xml"
echo ""
cvs -q -R -d /home/ncvs co -p www/en/news/press.xml > press.xml

#
# Grep for URLs in press.xml and save them to links.txt
#
echo ""
echo "==> Finding links."
echo ""
grep '<url>' press.xml |\
sed -e 's|^.*<url>||' -e 's|</url>.*$||' |\
grep -v '^$' > links.txt

#
# Check those links, and save output to ./logfile
#
echo ""
echo "==> Testing links."
echo ""
for url in `cat links.txt` ;do
	echo -n "${url}"
	fetch -4 -A -q -T 120 -o /dev/null "${url}" 2>/dev/null
	if [ $? -eq 0 ]; then
		echo ' OK'
	else
		echo ' FAILED'
	fi
done | tee "${log}"

echo ""
echo "==> Grepping for failed links."
echo ""
grep FAILED "${log}" > "FAILED.${log}"
