# Syncthing-for-PocketBook
Launch [Syncthing](https://syncthing.net/) on PocketBook 

<p align="center">
    <img src="res/good.jpg" width="60%">
</p>


Протестировано на PB740<br>
Версия ПО U740.6.5.1379<br>
Версия Syncthing v1.27.2, Linux (32-bit ARM)

## Установка

- Создать папку *syncthing* во внутренней памяти `ext1\applications\syncthing`

- Скопировать конфиг *config.xml* в `ext1\applications\syncthing`

- Скопировать *syncthing.app* в `ext1\applications`

- Скачать версию [Linux 32-bit ARM](https://github.com/syncthing/syncthing/releases/download/v1.27.2/syncthing-linux-arm-v1.27.2.tar.gz)

- Извлечь в созданную папку `ext1\applications\syncthing\` бинарь - *syncthing* (24mb размер)

### Настройка иконки

Делайте этот [шаг](https://github.com/jjrrw174/PocketBook-Desktop-and-App-Customizations?tab=readme-ov-file#adding-custom-app-icons-images) только если уверены и сделали бэкап изменяемых файлов.<br>
Нужно аккуратно отредактировать *view.json* вашего устройства и скопировать *icons*

<details> <summary>Должно получиться так:</summary>
 <p align="center">
    <img src="res/icon_example_display.jpg" width="35%">
</p> 
</details> 

## Примечания
Чтобы все заработало после включения нужно врубить вай-фай и запустить приложение @syncthing.<br> Далее оно будет работать незримо.<br>Чтобы папки подцепились нужно задать игнорирование прав.<br> Подробнее в ссылке ниже.

## Ссылки

[Install Syncthing on PocketBook](https://blog.tastytea.de/posts/syncthing-on-pocketbook/)

[Root for PB740](https://www.mobileread.com/forums/showthread.php?t=325185)

[PocketBookTerminal](http://users.physik.fu-berlin.de/~jtt/PB/)

[Create 8bit bmp icon for PocketBook](https://gist.github.com/mikedigriz/6830eaaedcbba99afbe216c3d9195c06)
