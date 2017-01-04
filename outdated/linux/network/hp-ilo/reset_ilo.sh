#!/usr/bin/expect
set timeout 600  
set ip [lindex $argv 0]
set pass [lindex $argv 1]
spawn ssh Administrator@$ip
set answ "$pass"
set comm1 "reset /map1"
expect "Administrator@$ip's password:"
send "$answ\r"
expect "</>hpiLO->"
send "$comm1\r"
expect eof

