#!/bin/sh
## Refresh PocketBook librery without reboot device!
## You can see new files on main screen and folder explorer
sync
# kill syncthing app
killall syncthing 2> /dev/null
# start lib update on bg, but not from user sreader
/ebrmain/bin/scanner.app &
timeout -t 3 /ebrmain/bin/dialog 1 '' 'Press OK or just wait!' 'OK'
# kill all u=reader scan processes on bg
killall scanner.app &> /dev/null &
