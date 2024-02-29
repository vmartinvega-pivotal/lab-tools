#!/usr/bin/expect

#Usage sshsudologin.expect 
# <host> (0)
# <ssh user> (1)
# <password user> (2)
# <samba user> (3)
# <samba password> (4)

set timeout 60

# Initialize the Virtual Data Domain
spawn ssh -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" [lindex $argv 1]@[lindex $argv 0]

expect "yes/no" { 
	send "yes\r"
	expect "*?assword" { send "[lindex $argv 2]\r" }
	} "*?assword" { send "[lindex $argv 2]\r" }

expect "*:*" { send "sudo smbpasswd -a [lindex $argv 3]\r" }
expect "*password for*" { send "[lindex $argv 2]\r" }
expect "*New SMB password*" { send "[lindex $argv 4]\r" }
expect "*Retype new SMB password*" { send "[lindex $argv 4]\r" }
expect "*:*" { send "exit\r" }
expect eof
