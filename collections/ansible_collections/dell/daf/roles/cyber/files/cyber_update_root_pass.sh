#!/usr/bin/expect

#Usage sshsudologin.expect 
# <host> (0)
# <ssh user> (1)
# <ssh password> (2) 
# <root password> (3) 
# <new root password> (4) 

set timeout 60

# Initialie the Virtual Data Domain
spawn ssh -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" [lindex $argv 1]@[lindex $argv 0]

expect "yes/no" { 
	send "yes\r"
	expect "*?assword" { send "[lindex $argv 2]\r" }
	} "*?assword" { send "[lindex $argv 2]\r" }

expect "admin*:*" { send "sudo su\r" }
expect "*password for root:*" { send "[lindex $argv 3]\r" }
expect "*UNIX password:*" { send "[lindex $argv 3]\r" }
expect "*New*" { send "[lindex $argv 4]\r" }
expect "*Retype*" { send "[lindex $argv 4]\r" }
expect "*:*" { send "exit\r" }
expect "*:*" { send "exit\r" }
expect eof
