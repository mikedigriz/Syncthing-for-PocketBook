#!/ebrmain/bin/run_script -bitmap=ci_autosync_cloud &

# Advanced Syncthing launcher: show live status when running, or start if stopped.
# See docs/SCRIPTS.md for details on the lock mechanism.

APP_DIR="/mnt/ext1/applications/syncthing"
CONFIG="$APP_DIR/config.xml"
SOCK="/tmp/syncthing.sock"
LOCK="/tmp/syncthing.lock"
DIALOG="/ebrmain/bin/dialog"
WAIT="timeout -t 3"

# Already running: show live status, then stop

pidof syncthing > /dev/null
RUNNING=$?

APIKEY=$(grep -o '<apikey>[^<]*' "$CONFIG" | sed 's#.*>##')
FOLDER=$(grep -o '<folder id="[^"]*"' "$CONFIG" | head -n1 | sed 's#.*id="##;s#"##')
BODY=$(curl --max-time 2 -s --unix-socket "$SOCK" -H "X-API-Key: $APIKEY" "http://localhost/rest/db/status?folder=$FOLDER" 2>/dev/null)

STATE=$(echo "$BODY" | sed -n 's/.*"state": *"\([^"]*\)".*/\1/p' | sed 's/^idle$/Up to date/;s/^syncing$/Syncing files.../;s/^scanning$/Scanning files.../;s/^cleaning$/Cleaning up.../;s/^error$/Sync error/')
FILES_TOTAL=$(echo "$BODY" | sed -n 's/.*"globalFiles": *\([0-9]*\).*/\1/p')
FILES_SYNCED=$(echo "$BODY" | sed -n 's/.*"inSyncFiles": *\([0-9]*\).*/\1/p')
ERRORS=$(echo "$BODY" | sed -n 's/.*"errors": *\([0-9]*\).*/\1/p')
LAST_SYNC=$(echo "$BODY" | sed -n 's/.*"stateChanged": *"[0-9-]*T\([0-9]*:[0-9]*\):[0-9]*.*/\1/p')
MSG=$(printf '%s\nLast Sync: %s\nFiles: %s of %s synced\nErrors: %s' "${STATE:-Status unknown}" "${LAST_SYNC:-?}" "${FILES_SYNCED:-?}" "${FILES_TOTAL:-?}" "${ERRORS:-0}")

if [ "$RUNNING" -eq 0 ]; then
    $WAIT $DIALOG 1 "" "$MSG" "OK"
    exit 0
fi

# Not running: claim the lock, then launch

mkdir "$LOCK" 2>/dev/null || exit 0

$WAIT $DIALOG 1 "" "Syncthing started" "OK"

/ebrmain/bin/netagent net on &> /dev/null &

setsid sh -c "$APP_DIR/syncthing --home=\"$APP_DIR\" 2>&1 | grep ERR > $APP_DIR/syncthing.log" &
