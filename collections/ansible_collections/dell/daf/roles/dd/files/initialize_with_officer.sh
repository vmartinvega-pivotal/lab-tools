#!/usr/bin/expect

#Usage sshsudologin.expect 
# <host> (0)
# <ssh user> (1)
# <ssh password> (2) 
# <new ssh password> (3) 
# <user officer> (4)
# <user officer password> (5)
# <fqdn> (6)
# <domain> (7)
# <ethV0 ip> (8)
# <ethV0 mask> (9)
# <ethV1 ip> (10)
# <ethV1 mask> (11)
# <default gateway> (12)
# <dns> (13)

set timeout 60

# Initialize the Virtual Data Domain
spawn ssh -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" [lindex $argv 1]@[lindex $argv 0]

expect "yes/no" { 
	send "yes\r"
	expect "*?assword" { send "[lindex $argv 2]\r" }
	} "*?assword" { send "[lindex $argv 2]\r" }

expect "EULA_80.txt" { send "q\r" }
expect "Press any key then hit enter to acknowledge the receipt of EULA information:" { send "q\r" }
expect "*Enter new password:*" { send "[lindex $argv 3]\r" }
expect "*Re-enter new password:*" { send "[lindex $argv 3]\r" }
expect "*Do you want to create security officer*" { send "yes\r" }
expect "*Username*" { send "[lindex $argv 4]\r" }
expect "*Enter new password:*" { send "[lindex $argv 5]\r" }
expect "*Re-enter new password:*" { send "[lindex $argv 5]\r" }
expect "*Do you want to configure system using GUI wizard*" { send "yes\r" }
expect "*Configure Network at this time*" { send "yes\r" }
expect "*At least one interface needs to be configured using DHCP*" { send "no\r" }
expect "*localhost.lan*" { send "[lindex $argv 6]\r" }
expect "*lan*" { send "[lindex $argv 7]\r" }
expect "*Enable Ethernet port ethV0*" { send "yes\r" }
expect "*Use DHCP on Ethernet port ethV0*" { send "no\r" }
expect "*:*" { send "[lindex $argv 8]\r" }
expect "*255.255.255.0*" { send "[lindex $argv 9]\r" }
expect "*Enable Ethernet port ethV1*" { send "yes\r" }
expect "*Use DHCP on Ethernet port ethV1*" { send "no\r" }
expect "*:*" { send "[lindex $argv 10]\r" }
expect "*255.255.255.0*" { send "[lindex $argv 11]\r" }
expect "*:*" { send "[lindex $argv 12]\r" }
expect "*:*" { send "\r" }
expect "*:*" { send "[lindex $argv 13]\r" }
expect "*Do you want to save these settings*" { send "Save\r" }
expect eof
