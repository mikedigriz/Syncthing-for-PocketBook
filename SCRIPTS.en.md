<p align="right">
  <a href="https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/SCRIPTS.en.md">
    <img src="https://img.shields.io/badge/lang-en-red.svg" alt="en">
  </a>
    <a href="https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/SCRIPTS.md">
    <img src="https://img.shields.io/badge/lang-ru-blue.svg" alt="ru">
  </a>
</p>

# Script notes

This explains why `syncthing_pro.app` looks odd. Keep it in mind if you edit it, otherwise the script will stop launching.

## Why so many `\r`

PocketBook's `run_script` needs CRLF line endings. Don't save the file as LF.

Because of that, almost every line has its quirks:

- Each line ends with `;`. That closes the command, and the leftover `\r` just fails as an empty command without breaking anything.
- Check the exit code (`$?`) on the same line as the command. On the next line it would already be wrong, overwritten by that same `\r`.
- Blank lines aren't really blank, they have a `#`. A truly empty line is just a `\r`, and ash trips over it.
- Don't split `if/then/fi` and the like across lines. A stray `\r` on a keyword breaks parsing for the whole file.

## Everything else

- The status comes over the unix socket `/tmp/syncthing.sock`, not TCP. The script runs in a network sandbox and can't see `127.0.0.1` or the network, only files.
- Only `ERR` lines go to the log, otherwise it would grow forever.

## The lock

On launch `syncthing_pro.app` takes a lock with `mkdir /tmp/syncthing.lock`. It guards against a second launch: if the folder already exists, `mkdir` fails and the script exits instead of spawning a second process.

Important: the lock is released by `syncthing_kill.app` with `rmdir /tmp/syncthing.lock`. Remove that line and the lock stays behind after you stop syncthing, so `syncthing_pro.app` won't start again until you delete the folder by hand or reboot the device.
