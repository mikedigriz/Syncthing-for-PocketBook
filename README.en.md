<p align="right">
  <a href="https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/README.en.md">
    <img src="https://img.shields.io/badge/lang-en-red.svg" alt="en">
  </a>
    <a href="https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/README.md">
    <img src="https://img.shields.io/badge/lang-ru-blue.svg" alt="ru">
  </a>
</p>

[![Syncthing-for-PocketBook](res/syncthing-pb-logo.png)](https://syncthing.net/)
## Launch [Syncthing](https://syncthing.net/) on PocketBook 
Tested on PB740 (InkPad 3) v6.8.4473<br>
Syncthing 2.0.12, Linux version (32-bit ARM)<br>
Also works on:
\
\-  PocketBook 700 Era Color (PB700K3)
\
\-  PocketBook 650 check issue [#6](https://github.com/mikedigriz/Syncthing-for-PocketBook/issues/6)

This repository contains instructions for installing and setting up the Syncthing application on your PocketBook device. Syncthing is a file synchronization program that allows you to sync files between devices over the internet or local network. In this case, it enables you to synchronize books and other documents between your PocketBook and other devices such as a computer or smartphone. Your data remains entirely yours and is stored only on your own devices.

## Migration to Syncthing 2.0

- Change the arguments in syncthing.app to start with `--`
e.g. `-home` must be given as `--home`

*Rollback is possible, syncthing makes backups of databases and configs itself.*

## Installation

- Create a *syncthing* folder in internal memory `ext1\applications\syncthing`

- Copy config [*config.xml*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/config.xml) to `ext1\applications\syncthing`

- Copy [*syncthing.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing.app) to `ext1\applications`

- Download version [Linux 32-bit ARM](https://github.com/syncthing/syncthing/releases/download/v2.0.12/syncthing-linux-arm-v2.0.12.tar.gz)

- Extract to created folder `ext1\applications\syncthing\` binary file - *syncthing* (31mb size)


```
│── applications
|    │── syncthing
|    │   │── syncthing
|    │   └── config.xml
|    │
|    │── icons
|    │   │── syncthing_app_f.bmp
|    │   └── syncthing_app.bmp
|    │
|    └── syncthing.app
```

### Changing the Icon

> [!IMPORTANT]\
> Do this [step](https://github.com/jjrrw174/PocketBook-Desktop-and-App-Customizations/tree/16ae9294fafe287319311cca4e97675d66606a1d?tab=readme-ov-file#adding-custom-app-icons-images) only if you have made a backup of the file being modified.<br>

Change file [*view.json*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/view.json) of your device and copy the icons

<details> <summary>It should look like this:</summary>
 <p align="center">
    <img src="res/icon_example_display.jpg" width="35%">
</p> 
ROOT is not needed. The system folders are hidden.
	
Two entries `U_syncthing` have been added to `/system/config/desktop/view.json`

Between "applications" and "_comment":
```json
    "applications": {
        "U_syncthing": {
			"path": "/mnt/ext1/applications/syncthing.app",
			"title": "Syncthing",
			"icon": "/mnt/ext1/applications/icons/syncthing_app.bmp",
			"focused_icon": "/mnt/ext1/applications/icons/syncthing_app_f.bmp"
		},
        "_comment":
 ```

In Services section:
```json
            {
                "title": "@Services",
                "sort": "title",
                "apps": [
                    "PB_Dropbox",
                    "PB_Cloud",
                    "PB_SendToPB",
                    "U_syncthing"			
                ]
            },
```

Copied the icons syncthing_app.bmp, syncthing_app_f.bmp to `/mnt/ext1/applications/icons/`

</details> 

## Using

After turning on the device, you need to turn on the Wi-Fi and launch the Syncthing application. Wait about 20 seconds after clicking `OK` on first launch. Then it will work invisibly until it is turned off. The new files will be visible on the main page after the device is restarted.

*Everything is the same here as on other devices with Syncthing*
- Open in the browser: `http://your-ip-address:8384`
- Configure the folder, set the rights to be ignored


<details> <summary>Example of settings from the web panel</summary>
<p align="center">
    <img src="res/good.jpg" width="100%">
</p>
</details> 

### Synchronizing reading progress
The [Koreader](https://github.com/koreader/koreader) reader will help in this task.

Each open book has its own directory with the necessary lua-files, which makes it possible to read between devices.

## Links

[Install Syncthing on PocketBook](https://blog.tastytea.de/posts/syncthing-on-pocketbook/)


[Convert to 8bit bmp icon](https://gist.github.com/mikedigriz/6830eaaedcbba99afbe216c3d9195c06)

Special thanks to [the forum](https://forum.syncthing.net/t/pls-release-a-version-for-pocketbook/21370/) for the additions!
