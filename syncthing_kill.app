#!/bin/sh
## Refresh PocketBook librery without reboot device!
## You can see new files on main screen and folder explorer
sync
# kill syncthing app
killall syncthing 2> /dev/null
# release the lock so it can start again
rmdir /tmp/syncthing.lock 2> /dev/null
# disable wi-fi
/ebrmain/bin/netagent net off &> /dev/null &
# start lib update on bg, but not from user sreader
/ebrmain/bin/scanner.app &
sleep 3
# kill all u=reader scan processes on bg
killall scanner.app &> /dev/null &
