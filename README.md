<p align="right">
  <a href="https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/README.en.md">
    <img src="https://img.shields.io/badge/lang-en-red.svg" alt="en">
  </a>
    <a href="https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/README.md">
    <img src="https://img.shields.io/badge/lang-ru-blue.svg" alt="ru">
  </a>
</p>

[![Syncthing-for-PocketBook](res/syncthing-pb-logo.png)](https://syncthing.net/)
## Запуск [Syncthing](https://syncthing.net/) на PocketBook 
Протестировано на PB740 (InkPad 3) v6.8.4473<br>
Версия Syncthing 2.1.1, Linux (32-bit ARM)<br>
Также работает на:
\
\-  PocketBook 700 Era Color (PB700K3)
\
\-  PocketBook 650 смотри [issue #6](https://github.com/mikedigriz/Syncthing-for-PocketBook/issues/6)

Этот репозиторий содержит инструкции по установке и настройке программы Syncthing на PocketBook. Syncthing — это программа для синхронизации файлов между устройствами через интернет или локальную сеть. В данном случае, она позволяет синхронизировать книги и другие документы между вашим PocketBook и другими устройствами, такими как компьютер или смартфон. Данные только ваши, и хранятся только на ваших устройствах.


## Установка

- Создать папку *syncthing* во внутренней памяти `ext1\applications\syncthing`

- Скопировать конфиг [*config.xml*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/config.xml) в `ext1\applications\syncthing`

- Скопировать [*syncthing.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing.app) в `ext1\applications`

- Скачать версию [Linux 32-bit ARM](https://github.com/syncthing/syncthing/releases/download/v2.1.1/syncthing-linux-arm-v2.1.1.tar.gz)

- Извлечь в созданную папку `ext1\applications\syncthing\` бинарь - *syncthing* (24mb размер)


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

### Настройка иконки

> [!IMPORTANT]\
> Делайте этот [шаг](https://github.com/jjrrw174/PocketBook-Desktop-and-App-Customizations/tree/16ae9294fafe287319311cca4e97675d66606a1d?tab=readme-ov-file#adding-custom-app-icons-images) только если сделали бэкап изменяемого файла.

Измените файл [*view.json*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/view.json) своего устройства и скопируйте значки

<details> <summary>Должно получиться так:</summary>
 <p align="center">
    <img src="res/icon_example_display.jpg" width="35%">
</p> 
ROOT не нужен. Системные папки скрыты.
	
Добавлены 2 записи U_syncthing в `ext1\system\config\desktop\view.json`

Между "applications" и "_comment":
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

В секцию Services:
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

Скопированы иконки syncthing_app.bmp, syncthing_app_f.bmp в `ext1\applications\icons\`

</details> 

## Использование

Запустите Syncthing. Первый запуск займет около 20 секунд после нажатия кнопки `ОК`. Далее оно будет работать незримо до выключения. Новые файлы будут видны на главной странице после перезагрузки устройства. Или вы можете попробовать эксперементальное решение [*syncthing_kill.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing_kill.app)

*Здесь все так же как и на других устройствах с Syncthing*
- Открыть в браузере адрес: `http://your-ip-address:8384`
- Настроить папку, задать игнорирование прав


<details> <summary>Пример настроек из веб-панели</summary>
<p align="center">
    <img src="res/good.jpg" width="100%">
</p>
</details> 

## Для Pro (расширенный скрипт)

> [!IMPORTANT]\
> Этот вариант для тех, кто уже разобрался с обычным [*syncthing.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing.app) и у кого он стабильно работает. Если базовый скрипт ещё не настроен, сначала доведите его до ума, а уже потом возвращайтесь сюда.

Обычный скрипт умеет ровно одно: запустить syncthing. [*syncthing_pro.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing_pro.app) делает больше.

Что в нём удобнее:
- Тап, запускается. Работает? Тап, показывает статус.
- В статусе видно: идёт ли синхронизация, когда синхронизировались в последний раз, сколько файлов уже на месте и есть ли ошибки.
- Открывается шустрее, экран не моргает на каждый тап.

Как перейти:

1. Скопируйте [*syncthing_pro.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing_pro.app) в `ext1\applications`. Можно вместо обычного, можно рядом, прописав ещё одну запись в `view.json`.
2. Остановите syncthing и поправьте секцию `gui` в `ext1\applications\syncthing\config.xml`:

```xml
    <gui enabled="true" tls="false" sendBasicAuthPrompt="false">
        <address>/tmp/syncthing.sock</address>
    </gui>
```

3. Для остановки используйте [*syncthing_kill.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing_kill.app). Убедитесь, что в нём есть строка `rmdir /tmp/syncthing.lock`. `syncthing_pro.app` при запуске ставит блокировку через `mkdir /tmp/syncthing.lock`, чтобы не плодить второй процесс. Если её не снять, syncthing больше не запустится, пока не удалите папку вручную или не перезагрузите устройство.

> [!WARNING]\
> После этой правки веб-мордочка по адресу `http://your-ip-address:8384` перестанет открываться. Поэтому все папки настройте заранее. Захотите вернуть панель, просто верните обратно адрес `0.0.0.0:8384`.

### Синхронизация прогресса чтения
В этой задаче поможет читалка [Koreader](https://github.com/koreader/koreader).

К каждой открытой книге создается своя директория с нужными lua-файлами, что дает возможность чтения между устройствами.

## Ссылки

[Install Syncthing on PocketBook](https://blog.tastytea.de/posts/syncthing-on-pocketbook/)

[Convert to 8bit bmp icon](https://gist.github.com/mikedigriz/6830eaaedcbba99afbe216c3d9195c06)

Отдельное спасибо [форуму](https://forum.syncthing.net/t/pls-release-a-version-for-pocketbook/21370/) за дополнения!
