#!/bin/sh

#
# git push scriptbox repo to githublo
#

dated=`date +%Y-%m-%d-%H%M%S`

git add .

echo run git push on ${dated}

for i in `git status | grep deleted | awk '{print $2}'`; do git rm $i; done

# hardcode proxy, becouse banned in russia :-(
git commit -m "$dated $(curl -L http://192.168.0.11:3129 -s http://whatthecommit.com/index.txt)"

git push -u origin main

#
# non master, just a main. fck2020 (c) scooter
#
