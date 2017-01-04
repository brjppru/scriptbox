#!/bin/sh

t=" bytes"
d=
use=ipfw
ti=1
di=day
B=no

usage () {
echo "Usage: bw.sh [-bkmgin]"
echo "Options:"
echo "  -b   Show output in bytes [default]"
echo "  -k   Show output in KB"
echo "  -m   Show output in MB"
echo "  -g   Show output in GB"
echo "  -i   Use ipfw to determine traffic (needs root) [default]"
echo "  -n   Use netstat to determine traffic"
echo "  -f   Force use of ipfw method even if not root"
echo "  -M   Print bandwidth per month, rather than per day"
echo "  -Y   Print bandwidth per year, rather than per day"
echo "  -H   Print bandwidth per hour, rather than per day"
echo "  -I   Print bandwidth per minute, rather than per day"
echo "  -S   Print bandwidth per second, rather than per day"
echo "  -D   Print bandwidth per day [default]"
echo "Note: netstat gives the wrong value on systems which use a lot"
echo "     of bandwidth."
echo "Note: A year has 365 days; a month has 28 days."
}

args=`getopt bkmghinfHMSDYI $*`
if [ $? != 0 ]; then
	usage
	exit 2
fi
set -- $args

for i
do
	case "$i"
	in
		-b) t=" bytes"
		    d=
		    shift;;
		-k) t=KB
		    d="/1024"
		    shift;;
		-m) t=MB
		    d="/1024/1024"
		    shift;;
		-g) t=GB
		    d="/1024/1024/1024"
		    shift;;
		-i) use=ipfw
		    shift;;
		-n) use=netstat
		    shift;;
		-f) forceroot=yes
		    shift;;
		-h) usage
		    exit;;
		-H) ti=24
		    di="hour"
		    shift;;
		-I) ti=1440
		    di="minute"
		    shift;;
		-S) ti=86400
		    di="second"
		    shift;;
		-D) ti=1
		    di="day"
		    shift;;
		-M) B=yes
		    ti=28
		    di="month"
		    shift;;
		-Y) B=yes
		    ti=365
		    di="year"
		    shift;;
	esac
done

if [ $use = ipfw ]; then
	if [ `id -u` \!= 0 -a X$forceroot \!= Xyes ]; then
		echo "You must be root to use ipfw method."
		exit
	fi
	bw=`(echo scale=30;echo \(\`ipfw show|sed -e '/Dynamic/,$d'|awk '{print $3;}'|xargs echo -n|sed -e "s/ /+/g"\`\)$d)|bc`
else
	bw=`(echo scale=30;echo \(\`netstat -Wbi|sed -e 1d|cut -c 59-68,84-93|tr -s ' '|sed -e 's/^ *//'|cut -d" " -f 1,2|xargs echo -n|sed -e 's/ /+/g'\`\)$d;echo)|bc`
fi

days=`uptime|awk '{print $3;}'`
bpd=`(echo scale=2; echo $bw $days|sed -e "s/ /\\//g")|bc`
if [ $B = no ]; then
	bpd=`(echo scale=2; echo $bpd $ti|sed -e "s/ /\\//g")|bc`
else
	bpd=`(echo scale=2; echo $bpd $ti|sed -e "s/ /\\*/g")|bc`
fi

tbw=`(echo scale=2; echo ${bw}/1)|bc`
echo ${tbw}$t in $days days \(${bpd}$t per $di\)
