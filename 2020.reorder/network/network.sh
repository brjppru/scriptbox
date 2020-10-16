#!/usr/bin/env bash

online=$(ip addr | grep "state UP" | cut -d ":" -f2)

#connected=""
#offline=""
connected=""
offline=""
if [[ "$online" ]]; then
  echo ${connected}
else
  echo ${offline}; sleep 0.6; echo ${connected}
fi
