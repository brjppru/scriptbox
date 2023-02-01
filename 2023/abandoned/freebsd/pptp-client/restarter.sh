#!/bin/sh

if [ -z $1 ]; then              
    echo "This script restart services, don't run it!"
    exit 1                        
fi                              

# postfix restart

killall -HUP named

postfix reload

