#!/bin/sh
# Проверяет .app-скрипты: BOM, CRLF, отсутствие финального перевода строки,
# шебанг и синтаксис. Запускается локально и в CI.
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

fail=0
err() {
    printf '%s: %s\n' "$1" "$2" >&2
    fail=1
}

for f in *.app; do
    [ -e "$f" ] || continue

    if head -c 3 "$f" | od -An -tx1 | tr -d ' \n' | grep -q '^efbbbf'; then
        err "$f" 'BOM перед шебангом - PocketBook не запустит скрипт'
    fi

    if awk '/\r/ { found = 1 } END { exit !found }' "$f"; then
        err "$f" 'CRLF - на устройстве шебанг сломается'
    fi

    if [ -n "$(tail -c 1 "$f")" ]; then
        err "$f" 'нет перевода строки в конце файла'
    fi

    if ! head -n1 "$f" | grep -qE '^#!(/bin/sh|/ebrmain/bin/run_script)'; then
        err "$f" 'неожиданный шебанг'
    fi

    # Шебанг run_script не понимают ни sh, ни shellcheck, поэтому проверяем копию
    tmp=$(mktemp)
    { printf '#!/bin/sh\n'; tail -n +2 "$f"; } > "$tmp"
    sh -n "$tmp" || err "$f" 'синтаксическая ошибка sh'
    if command -v shellcheck > /dev/null 2>&1; then
        shellcheck -s sh -S warning "$tmp" || err "$f" 'shellcheck'
    fi
    rm -f "$tmp"
done

# Конфиги, которые уезжают на устройство
if command -v xmllint > /dev/null 2>&1; then
    xmllint --noout config.xml || err config.xml 'невалидный XML'
fi
if command -v jq > /dev/null 2>&1; then
    jq -e . view.json > /dev/null || err view.json 'невалидный JSON'
fi

if [ "$fail" -eq 0 ]; then
    echo "OK: скрипты и конфиги в порядке"
fi
exit "$fail"
