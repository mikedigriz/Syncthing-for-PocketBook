<p align="right">
  <a href="https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/docs/SCRIPTS.en.md">
    <img src="https://img.shields.io/badge/lang-en-red.svg" alt="en">
  </a>
    <a href="https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/docs/SCRIPTS.md">
    <img src="https://img.shields.io/badge/lang-ru-blue.svg" alt="ru">
  </a>
</p>

# Script notes

## syncthing_pro.app

- **Status queries**: sends requests over the unix socket `/tmp/syncthing.sock`, not TCP. The script runs in a network sandbox and can't see `127.0.0.1` or the network, only files and sockets.
- **Logging**: only lines containing `ERR` are written to `syncthing.log`, otherwise the file would grow unbounded on the device's limited storage.

## The lock

On launch `syncthing_pro.app` takes a lock with `mkdir /tmp/syncthing.lock`. It guards against a second launch: if the folder already exists, `mkdir` fails and the script exits instead of spawning a second process.

Important: the lock is released by `syncthing_kill.app` with `rmdir /tmp/syncthing.lock`. Remove that line and the lock stays behind after you stop syncthing, so `syncthing_pro.app` won't start again until you delete the folder by hand or reboot the device.

## Debugging on the device

To look inside and figure out why a script fails, these come in handy:
- [pb-terminal](https://github.com/CatInBeard/pb-terminal): a terminal right on the reader.
- [pbsshd](https://www.mobileread.com/forums/attachment.php?attachmentid=123724&d=1402034568): SSH access.
- [rsh](https://www.mobileread.com/forums/showthread.php?t=116350&highlight=pocketbook+rsh): another way into the shell.
- [root for the device](https://www.mobileread.com/forums/showthread.php?t=325185): dangerous, it may break the device.

Inspect binaries with `strings`, for example `strings /ebrmain/bin/netagent`. It's a handy way to see which commands and paths the firmware actually has (especially useful on older models where the command set differs).

## Line endings in scripts

> [!IMPORTANT]\
> All script files (`.app`, `.sh`) MUST use **LF** (Line Feed, `\n`), not CRLF (Carriage Return + Line Feed, `\r\n`).

On Windows, Git by default converts LF to CRLF and vice versa, but PocketBook scripts require strictly LF. Using CRLF will break the scripts.

**How to check and fix:**
- **VS Code**: click `CRLF` in the bottom right corner → select `LF`
- **Sublime Text**: Menu → View → Line Endings → Unix (LF)
- **Other editors**: check their line ending settings

Git automatically converts line endings according to [.gitattributes](.gitattributes), but it's better to verify your editor settings.
