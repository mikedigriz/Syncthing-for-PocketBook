#!/bin/sh
## Kill Syncthing and refresh PocketBook librery without reboot device!
## You can see new files on main screen and folder explorer
killall syncthing 2> /dev/null
# start lib update on bg, but not from user sreader
/ebrmain/bin/scanner.app &
/ebrmain/bin/dialog 1 '' 'Press OK and wait!' 'OK'
# kill all u=reader scan processes work on bg
killall scanner.app &> /dev/null &
