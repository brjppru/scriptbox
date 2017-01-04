#!/bin/sh

# Before asking why I use wget, but not just writing to file
# think of this running on different hosts

smsgate()
{
    sender="`gnokii --getsms SM 1 2> /dev/null | grep Sender | awk '{print $2}' 2> /dev/null`";
    [ -z "$sender" ] || {
        result="$(gnokii --getsms SM 1 2> /dev/null | sed '1,/^Text:/ d' 2> /dev/null)";
        echo $sender:$result >> /home/kolo/sms.log;
	wget -O -q /dev/null "http://example.org/stuff/getsms.php?pass=****&sender=$sender&text=$result" > /dev/null 2> /dev/null
        gnokii --deletesms SM 1 >/dev/null 2> /dev/null
    }
}

while true
do
    smsgate
    sleep 10
done