#!/usr/local/bin/bash

# Список доменов, запрещённых к регистрации в зоне «.рф»  Оказывается существует список доменов, которые запрещено регистрировать в зоне «.рф». Полюбопытствуйте, расширьте свой словарный запас! Старательные люди собирали, там более четырёх тысяч доменов.
# http://bolknote.ru/2013/01/10/~3831/

curl -so- http://flisti.ru/stop-list.txt |
iconv -f cp1251 | awk -F'[\t\.]' 'BEGIN {srand()} $3 {print rand(), $3}' |
sort -n | awk '{print $2; exit}' | tee >(cut -c1 | tr '[:lower:]' '[:upper:]') |
sed -n '1s/^.//;1h;2p;2g;2p' | tr -d '\n' ; echo '!'

curl -so- http://flisti.ru/stop-list.txt |
iconv -f cp1251 | awk -F'[\t\.]' 'BEGIN {srand()} $3 {print rand(), $3}' |
sort -n | awk '{print $2"!"; exit}'

curl -so- http://flisti.ru/stop-list.txt | iconv -f cp1251 |
awk 'BEGIN {srand()} {print rand()"."$2}' |
sort -nt. | head -1 | cut -f2 -d. |
tee >(cut -c1 | tr '[:lower:]' '[:upper:]') | tail -r | tr -d '\n' | xargs -I? echo ?! | cut -c1,3-

curl -so- http://flisti.ru/stop-list.txt |
iconv -f cp1251 | grep -Eo '\s.+рф' | cat -b |
tee >(echo $((`wc -l`*$RANDOM/32768))) | tail -r |
grep -w `head -1` | cut -f3 | cut -d. -f1 | xargs -I? echo ?!
