#!/usr/bin/expect

#Usage sshsudologin.expect 
# <host> (0)
# <ssh user> (1)
# <ssh password> (2) 
# <command> (3) 

set timeout 60

# Initialie the Virtual Data Domain
spawn ssh -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" [lindex $argv 1]@[lindex $argv 0]

expect "yes/no" { 
	send "yes\r"
	expect "*?assword" { send "[lindex $argv 2]\r" }
	} "*?assword" { send "[lindex $argv 2]\r" }

expect "*#*" { send "[lindex $argv 3]\r" }

expect "*Do you want to configure system using GUI wizard*" { send "no\r" }
expect "*Configure Network at this time*" { send "no\r" }
expect "*Configure eLicenses at this time*" { send "no\r" }
expect "*Configure System at this time*" { send "no\r" }
expect "*Configure DDBOOST at this time*" { send "no\r" }
expect "*#*" { send "exit\r" }
expect eof
