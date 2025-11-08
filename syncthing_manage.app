#!/ebrmain/bin/run_script -clear_screen -bitmap=e3_black_empty_round

manage_app() {
    /ebrmain/bin/dialog 1 "" "Syncthing started" @TurnOn @TurnOff @Cancel
    status="$?"
    echo "$(date '+%Y-%m-%d %H:%M:%S') Dialog exit status: $status" >> /tmp/log.txt

    if [ "$status" -eq 1 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Status 1 - starting Syncthing" >> /tmp/log.txt
        $(/mnt/ext1/applications/syncthing/syncthing --home="/mnt/ext1/applications/syncthing" &> /dev/null &)

    elif [ "$status" -eq 2 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Status 2 - killing Syncthing process" >> /tmp/log.txt
        killall syncthing && echo "$(date '+%Y-%m-%d %H:%M:%S') Syncthing stopped" >> /tmp/log.txt

    elif [ "$status" -eq 3 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') Status 3 - action cancelled" >> /tmp/log.txt

    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') Unknown status: $status" >> /tmp/log.txt
    fi
}

manage_app
