#!/usr/bin/expect
set timeout 600  
set ip [lindex $argv 0]
set pass [lindex $argv 1]
spawn ssh Administrator@$ip
set answ "$pass"
set comm1 "create /map1/accounts1 username=deployer password=PASSWORD name=deployer group=admin,config,oemhp_vm,oemhp_power,oemhp_rc"
expect "Administrator@$ip's password:"
send "$answ\r"
expect "</>hpiLO->"
send "$comm1\r"
expect "</>hpiLO->"
send "show /system1/network1/Integrated_NICs\r"
expect "</>hpiLO->"
send "exit\r"
expect eof
