#!/bin/sh

find . -print0 | xargs -0 mogrify -auto-orient -verbose -quality 100 -resize 1024x
