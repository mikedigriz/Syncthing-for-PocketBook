#!/ebrmain/bin/run_script -clear_screen -bitmap=ci_autosync_cloud &
timeout -t 3 /ebrmain/bin/dialog 1 "" "Syncthing started" "OK"

# Enable Wi-Fi
/ebrmain/bin/netagent net on &> /dev/null &

# Magic!
setsid /mnt/ext1/applications/syncthing/syncthing --home="/mnt/ext1/applications/syncthing" &> /dev/null &
