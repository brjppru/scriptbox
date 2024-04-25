#!/bin/bash

#
# git push scriptbox repo to githublo
#
# 2024.04.25 fix script for a days
#

dated=$(date +%Y-%m-%d-%H%M%S)
commt=$(curl -L -s http://whatthecommit.com/index.txt)

git add .

echo run git push on ${dated} ${commt}

for i in `git status | grep deleted | awk '{print $2}'`; do git rm $i; done

git commit -m "$dated $commt"

git push -u origin main

#
# non master, just a main. fck2020 (c) scooter
#
