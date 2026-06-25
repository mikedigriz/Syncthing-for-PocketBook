#!/ebrmain/bin/run_script -bitmap=ci_autosync_cloud &
# Advanced Syncthing launcher: show live status when running, or start if stopped.
# See docs/SCRIPTS.md for details on the lock mechanism.
APP_DIR="/mnt/ext1/applications/syncthing"
CONFIG="$APP_DIR/config.xml"
SOCK="/tmp/syncthing.sock"
LOCK="/tmp/syncthing.lock"
DIALOG="/ebrmain/bin/dialog"
WAIT="timeout -t 3"

# Already running: show live status, then exit
pidof syncthing > /dev/null
RUNNING=$?

if [ "$RUNNING" -eq 0 ]; then
    APIKEY=$(grep -o '<apikey>[^<]*' "$CONFIG" | sed 's#.*>##')

    # Aggregate progress across ALL folders in one request
    COMP=$(curl --max-time 2 -s --unix-socket "$SOCK" -H "X-API-Key: $APIKEY" http://localhost/rest/db/completion)
    PCT=$(echo  "$COMP" | sed -n 's/.*"completion": *\([0-9]*\).*/\1/p');  PCT=${PCT:-0}
    GB=$(echo   "$COMP" | sed -n 's/.*"globalBytes": *\([0-9]*\).*/\1/p'); GB=${GB:-0}
    NEEDB=$(echo "$COMP" | sed -n 's/.*"needBytes": *\([0-9]*\).*/\1/p');  NEEDB=${NEEDB:-0}
    NEEDI=$(echo "$COMP" | sed -n 's/.*"needItems": *\([0-9]*\).*/\1/p');  NEEDI=${NEEDI:-0}

    # Most recent contact across devices (skip never-seen 1970; ISO sorts lexically)
    LASTSEEN=$(curl --max-time 2 -s --unix-socket "$SOCK" -H "X-API-Key: $APIKEY" http://localhost/rest/stats/device \
               | grep -o '"lastSeen": *"[^"]*"' | sed 's/.*"\([0-9T:+-]*\)"$/\1/' \
               | grep -v '^1970' | sort | tail -n1 | sed 's/T/ /;s/\(.*:[0-9][0-9]\):[0-9][0-9].*/\1/')

    # Per-folder pass: pause from config/folders, state from db/status
    FOLDERS_RAW=$(curl --max-time 2 -s --unix-socket "$SOCK" -H "X-API-Key: $APIKEY" \
                  http://localhost/rest/config/folders | grep -o '"id": *"[^"]*"\|"paused": *[a-z]*')
    DETAILS=$(echo "$FOLDERS_RAW" | while IFS= read -r line; do
        case "$line" in
            '"id":'*)
                id=$(echo "$line" | sed 's/.*"\([^"]*\)"$/\1/')
                ;;
            '"paused":'*)
                p=$(echo "$line" | sed 's/.*: *//')
                [ -z "$id" ] && continue
                if [ "$p" = "true" ]; then
                    echo "0|$id: paused"
                else
                    S=$(curl --max-time 2 -s --unix-socket "$SOCK" -H "X-API-Key: $APIKEY" "http://localhost/rest/db/status?folder=$id")
                    st=$(echo  "$S" | sed -n 's/.*"state": *"\([^"]*\)".*/\1/p')
                    er=$(echo  "$S" | sed -n 's/.*"errors": *\([0-9]*\).*/\1/p');      er=${er:-0}
                    isf=$(echo "$S" | sed -n 's/.*"inSyncFiles": *\([0-9]*\).*/\1/p'); isf=${isf:-0}
                    gf=$(echo  "$S" | sed -n 's/.*"globalFiles": *\([0-9]*\).*/\1/p'); gf=${gf:-0}
                    if [ "$er" -gt 0 ]; then
                        echo "2|$id: error ($er)"
                    elif [ -z "$st" ]; then
                        echo "0|$id: starting"
                    elif [ "$st" != "idle" ]; then
                        echo "1|$id: $st ($isf/$gf)"
                    fi
                fi
                id=""
                ;;
        esac
    done)

    # Header: only severity 1/2 raise it; paused/starting stay quiet
    WORST=$(echo "$DETAILS" | sed -n 's/^\([0-9]\)|.*/\1/p' | sort -rn | head -n1)
    case "$WORST" in
        2) HEAD="Sync error" ;;
        1) HEAD="Syncing..." ;;
        *) [ "${NEEDI:-0}" -gt 0 ] && HEAD="Syncing..." || HEAD="Up to date" ;;
    esac

    DONEMB=$(( (GB - NEEDB) / 1048576 )); TOTMB=$(( GB / 1048576 ))
    PROG="$DONEMB of $TOTMB MB ($PCT%)"

    LINES=$(echo "$DETAILS" | sed '/^$/d' | sed 's/^[0-9]|//')
    N=$(echo "$LINES" | grep -c .)
    SHOWN=$(echo "$LINES" | head -n 4)
    [ "$N" -gt 4 ] && SHOWN="$SHOWN
...and $((N-4)) more"

    MSG="$HEAD
$PROG"
    [ -n "$LASTSEEN" ] && MSG="$MSG
Last seen: $LASTSEEN"
    [ -n "$LINES" ] && MSG="$MSG
$SHOWN"

    $WAIT $DIALOG 1 "" "${MSG:-Status unknown}" "OK"
    exit 0
fi

# Not running: claim the lock, then launch
mkdir "$LOCK" 2>/dev/null || exit 0
$WAIT $DIALOG 1 "" "Syncthing started" "OK"
/ebrmain/bin/netagent net on &> /dev/null &
setsid sh -c "$APP_DIR/syncthing --home=\"$APP_DIR\" 2>&1 | grep ERR > $APP_DIR/syncthing.log" &
