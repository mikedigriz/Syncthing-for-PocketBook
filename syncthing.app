#!/ebrmain/bin/run_script -clear_screen -bitmap=ci_autosync_cloud &
/ebrmain/bin/dialog 1 "" "Syncthing started" "OK"

# Magic!
$(/mnt/ext1/applications/syncthing/syncthing -home="/mnt/ext1/applications/syncthing" &> /dev/null &)