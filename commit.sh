#!/bin/sh

# git push ironman repo to github

dated=`date +%Y-%m-%d-%H%M%S`

git add .
echo run git push on ${dated}


for i in `git status | grep deleted | awk '{print $2}'`; do git rm $i; done

# git add -u .
#
# git commit -m 'some fix on '${dated} # nice ;-)

git commit -m "$dated $(curl -s http://whatthecommit.com/index.txt)"
git push -u origin master
