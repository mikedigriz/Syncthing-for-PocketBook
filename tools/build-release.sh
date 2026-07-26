#!/bin/sh
# Собирает zip с готовой структурой папок для карты памяти PocketBook.
# Использование: tools/build-release.sh [версия]
# Бинарь syncthing намеренно не входит в архив, его качает пользователь.
set -eu

VERSION=${1:-dev}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
DIST="$ROOT/dist"
PKG="$DIST/pkg"
ARCHIVE="$DIST/syncthing-for-pocketbook-$VERSION.zip"

# через sh: файл может лежать без бита выполнения (SMB, распакованный zip)
sh "$ROOT/tools/check-scripts.sh"

rm -rf "$DIST"
mkdir -p "$PKG/applications/syncthing" "$PKG/applications/icons" "$PKG/system/config/desktop"

cd "$ROOT"
# syncthing_pro.app в архив не входит: он требует ручной правки config.xml,
# это путь для тех, кто уже разобрался с базовой установкой
cp syncthing.app syncthing_kill.app reboot.app "$PKG/applications/"
cp icons/*.bmp "$PKG/applications/icons/"
cp config.xml "$PKG/applications/syncthing/"
# Своё view.json на устройстве не трогаем, кладём только образец
cp view.json "$PKG/system/config/desktop/view.json.example"
cp README.md README.en.md LICENSE "$PKG/"
cp docs/SCRIPTS.md docs/SCRIPTS.en.md "$PKG/"

cat > "$PKG/applications/syncthing/PUT_BINARY_HERE-RU.txt" << 'EOF'
В этой папке не хватает одного файла - самого бинаря syncthing.
В архив он не входит, качайте его у авторов Syncthing:

    https://github.com/syncthing/syncthing/releases/latest

Нужен файл syncthing-linux-arm-v2.*.*.tar.gz (32-bit ARM).
Достаньте из архива только бинарь `syncthing` (~24 МБ) и положите
рядом с этим файлом, в папку applications/syncthing/.

Остальное содержимое tar.gz не нужно. Эту подсказку после
установки бинаря можно удалить.
EOF

cat > "$PKG/applications/syncthing/PUT_BINARY_HERE.txt" << 'EOF'
One file is missing here: the syncthing binary itself.
It is not bundled, get it from the Syncthing authors:

    https://github.com/syncthing/syncthing/releases/latest

You need syncthing-linux-arm-v2.*.*.tar.gz (32-bit ARM).
Extract only the `syncthing` binary (~24 MB) from it and put it
next to this file, into applications/syncthing/.

Nothing else from the tar.gz is needed. This hint file can be
deleted once the binary is in place.
EOF

cat > "$PKG/INSTALL-RU.txt" << EOF
Syncthing for PocketBook $VERSION
Подробности в README.md, здесь короткий путь.

1. Скачайте бинарь syncthing (см. applications/syncthing/PUT_BINARY_HERE-RU.txt)
   и положите его в applications/syncthing/.

2. Скопируйте папку applications из этого архива в корень карты памяти
   (ext1), поверх существующей. Свои файлы она не затирает.

3. Что делают скрипты:
     syncthing.app       - запуск
     syncthing_kill.app  - остановка и обновление библиотеки
     reboot.app          - перезагрузка устройства

4. Иконка в меню - по желанию: правьте ext1/system/config/desktop/view.json
   своего устройства по образцу system/config/desktop/view.json.example,
   сделав бэкап. Без этого скрипты всё равно запускаются из проводника.
EOF

cat > "$PKG/INSTALL.txt" << EOF
Syncthing for PocketBook $VERSION
Full details in README.en.md, this is the short path.

1. Download the syncthing binary (see applications/syncthing/PUT_BINARY_HERE.txt)
   and put it into applications/syncthing/.

2. Copy the applications folder from this archive into the root of your
   memory card (ext1), merging with the existing one. Nothing of yours
   gets overwritten.

3. What the scripts do:
     syncthing.app       - start
     syncthing_kill.app  - stop and refresh the library
     reboot.app          - reboot the device

4. The menu icon is optional: edit ext1/system/config/desktop/view.json on
   your device following system/config/desktop/view.json.example, after
   backing it up. Without it the scripts still run from the file explorer.
EOF

# Воспроизводимый архив: одинаковый вход даёт одинаковый sha256
SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH:-$(git -C "$ROOT" log -1 --format=%ct 2> /dev/null || echo 0)}
find "$PKG" -exec touch -d "@$SOURCE_DATE_EPOCH" {} +

cd "$PKG"
find . -type f -printf '%P\n' | LC_ALL=C sort | zip -X -q "$ARCHIVE" -@
cd "$DIST"
sha256sum "$(basename "$ARCHIVE")" > "$ARCHIVE.sha256"

echo "собран $ARCHIVE"
cat "$ARCHIVE.sha256"
