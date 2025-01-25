#/bin/sh

# delete all brj post from twitter
# by Roman Y. Bogdanov, http://brj.pp.ru/

# see api, http://apiwiki.twitter.com/REST+API+Documentation
# method: destroy

# ==============
# Start rocking!
# ==============

# let it loop forever!

while true 
do

# first of all, fetch my feed and out to "twitdel"

curl http://twitter.com/statuses/user_timeline/6814932.rss | grep "statuses" | grep '<link>.*</link>' | sed -r 's/.*statuses\/(.*)<\/link>.*/\1/' > twitdel

# fetch url correct? ok. do destroy

if [ $? -eq 0 ]; then

    # do the magic:destroy with my login and pass

    for twid in `cat twitdel` 
    do
    curl --basic --user user:pass --data status="del" http://twitter.com/statuses/destroy/$twid.xml -o /dev/null;
    done
 
    # end the magic

fi

# and try fetch again

done

# and of all

