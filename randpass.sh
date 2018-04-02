#!/bin/bash

#set timeout 15

export pass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
#pass=$RANDOM
#set pass "shuf -i 2000-65000 -n 1"

echo $pass
cat emailheader.txt > newpass.txt
echo $pass >> newpass.txt

/usr/sbin/ssmtp user1@example.com user2@example.com < newpass.txt
mv newpass.txt currentpass

/usr/bin/expect <<- DONE

set timeout 10
puts $::env(pass)
spawn ssh administrator@192.168.1.254

expect "User:"
send "administrator\r"
expect "*assword:*"
send "Password\r"
send "\r"
expect " >"
send "\r"
#send "?\r"
send "config wlan disable 2\r"
send "config wlan security wpa akm psk set-key ascii $pass 2\r"
send "config wlan enable 2\r"
send "logout\r"
send "y\r"
#interact
expect eof
DONE
#EOF