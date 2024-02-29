#!/usr/bin/expect

#Usage sshsudologin.expect 
# <host> (0)
# <ssh user> (1)
# <ssh password> (2) 
# <new ssh password> (3) 

set timeout 60

# Initialie the Virtual Data Domain
spawn ssh -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" [lindex $argv 1]@[lindex $argv 0]

expect "yes/no" { 
	send "yes\r"
	expect "*?assword" { send "[lindex $argv 2]\r" }
	} "*?assword" { send "[lindex $argv 2]\r" }

expect "*UNIX password:*" { send "[lindex $argv 2]\r" }
expect "*New*" { send "[lindex $argv 3]\r" }
expect "*Retype*" { send "[lindex $argv 3]\r" }
expect "*" { send "exit\r" }
expect eof
