#!/bin/bash

#
# git push scriptbox repo to githublo
#

dated=$(date +%Y-%m-%d-%H%M%S)
commt=$(curl -L --proxy http://192.168.0.11:3129 -s http://whatthecommit.com/index.txt)

echo "$dated"
echo "$commt"



git add .

echo run git push on ${dated}

for i in `git status | grep deleted | awk '{print $2}'`; do git rm $i; done

git commit -m "$dated $commt"

exit 0

curl -L http://192.168.0.11:3129 http://whatthecommit.com/index.txt
# | grep "<p>" | sed 's/<p>//' | sed 's/^/"/' | sed 's/$/"/' | xargs git commit -m

curl -L --proxy http://192.168.0.11:3129 -s http://whatthecommit.com/index.txt

git push -u origin main

#
# non master, just a main. fck2020 (c) scooter
#
