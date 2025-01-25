#!/bin/sh

cd /usr/home/brj/porno/

# partypornokiller script (-;

mv index.html index.html.old

wget -q http://www.thehun.com/

diff -u index.html index.html.old > index.diff

if [ `ls -la index.diff | awk '{print $5}'` -ne 0 ]; then

rm index.diff
   
perl -e 'while (<>) {while (s/(\<a\shref\=.+?\<\/a\>)//) {print $1, "<br>\n"}}' < index.html > porno.links.tmp

MONTH=`date +%c | awk -F " " '{print $2}'`

case $MONTH in 

 0) FMONTH="January" ;;
 1) FMONTH="February" ;;
 2) FMONTH="March" ;;
 3) FMONTH="April" ;;
 4) FMONTH="May" ;;
 5) FMONTH="June"  ;;
 6) FMONTH="July" ;;
 7) FMONTH="August" ;;
 8) FMONTH="September" ;;
 9) FMONTH="October" ;;
10) FMONTH="November" ;;
11) FMONTH="December" ;;

esac

cat porno.links.tmp | grep $FMONTH > porno.links

fi

Инструкция: 

каждая из ссылок является ссылкой на отдельную страницу посвященную какой-нибудь 
тетке. На той странице в той или иной форме обязательно будет тупое 
завлекалово на платный порносайт. Как правило это просто картинки с сылками. 
Вам они не нужны. В любом случае все завлекалово должно быть очень ненавязчивым, 
то за чем вы пришли должно там быть в очевидном виде. Если же при заходе на 
страницу или при клике на картинку открывается новое окно значит та страница 
попала в руки мудаков и там вы ничего не увидите того чего искали, нужно 
быстро закрывать все открывшиеся дополнительные окна. В среднем таких битых 
ссылок не более пары в день. При некотором опыте вы сразу будете определять 
такие ссылки.

