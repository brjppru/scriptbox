#!/bin/bash

#
# git push scriptbox repo to githublo
#

dated=$(date +%Y-%m-%d-%H%M%S)
commt=$(curl -L --proxy http://192.168.0.11:3129 -s http://whatthecommit.com/index.txt)

git add .

echo run git push on ${dated} ${commt}

git rm `git status | grep deleted | awk '{print $2}'`

git commit -m "$dated $commt"

git push -u origin main

#
# non master, just a main. fck2020 (c) scooter
#
