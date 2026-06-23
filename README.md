<p align="right">
  <a href="https://github.com/syncthing/syncthing/releases/latest">
    <img src="https://img.shields.io/github/v/release/syncthing/syncthing?label=syncthing" alt="latest syncthing release">
  </a>
  <a href="https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/docs/SCRIPTS.md">
    <img src="https://img.shields.io/badge/docs-script%20notes-green.svg" alt="docs">
  </a>
  <a href="https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/README.en.md">
    <img src="https://img.shields.io/badge/lang-en-red.svg" alt="en">
  </a>
    <a href="https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/README.md">
    <img src="https://img.shields.io/badge/lang-ru-blue.svg" alt="ru">
  </a>
</p>

[![Syncthing-for-PocketBook](res/syncthing-pb-logo.png)](https://syncthing.net/)
## Запуск [Syncthing](https://syncthing.net/) на PocketBook 
**Протестировано:** PB740 (InkPad 3) v6.8.4473, Syncthing 2.1.1, Linux (32-bit ARM)

Также работает:
- PocketBook 700 Era Color (PB700K3)
- PocketBook 650, смотри [issue #6](https://github.com/mikedigriz/Syncthing-for-PocketBook/issues/6)

Syncthing синхронизирует книги и документы между вашим PocketBook и другими устройствами (компьютер, смартфон) через интернет или локальную сеть. Данные только ваши и хранятся только на ваших устройствах.


## Установка

1. На [странице релизов Syncthing](https://github.com/syncthing/syncthing/releases/latest) найдите файл с именем `syncthing-linux-arm-v2.*.*.tar.gz`, скачайте его и достаньте из архива только сам бинарь `syncthing` (~24 МБ), остальное не нужно.

2. Создайте папку `ext1\applications\syncthing` и положите туда:
   - бинарь `syncthing`
   - конфиг [*config.xml*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/config.xml)

3. Положите [*syncthing.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing.app) в `ext1\applications`.


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

ROOT не нужен. Папка `system` с файлом `view.json` скрытая, и показ скрытых файлов в каждой ОС включается по-своему:
- Windows (Проводник): вкладка «Вид» → «Показать» → «Скрытые элементы».
- macOS (Finder): нажмите `Cmd + Shift + .` (точка).
- Linux (большинство файловых менеджеров): нажмите `Ctrl + H`.

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

Запустите Syncthing. Первый запуск займёт около 20 секунд после нажатия кнопки `ОК`. Дальше работает в фоне и не мешает, пока не выключите. Новые файлы появятся на главной странице после перезагрузки устройства. Либо попробуйте экспериментальное решение [*syncthing_kill.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing_kill.app).

Всё остальное [как и на других устройствах с Syncthing](https://docs.syncthing.net/intro/getting-started.html):

1. Откройте в браузере адрес `http://your-ip-address:8384`. IP-адрес ридера смотрите в информации о подключённой сети Wi-Fi (например: зажать сеть, затем «Информация»).
2. Настройте папку и задайте игнорирование прав.


<details> <summary>Пример настроек из веб-панели</summary>
<p align="center">
    <img src="res/good.jpg" width="100%">
</p>
</details> 

## Для Pro (расширенный скрипт)

Этот вариант для тех, кто уже разобрался с обычным [*syncthing.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing.app) и у кого он стабильно работает. Если базовый скрипт ещё не настроен, сначала доведите его до ума, а уже потом возвращайтесь сюда.

Обычный скрипт умеет ровно одно: запустить syncthing. [*syncthing_pro.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing_pro.app) делает больше.

Что в нём удобнее:
- Тап, запускается. Работает? Тап, показывает статус.
- В статусе видно: идёт ли синхронизация, когда синхронизировались в последний раз, сколько файлов уже на месте и есть ли ошибки.
- Открывается шустрее, экран не моргает на каждый тап.

Сам диалог статуса (текст в нём всегда на английском, скрипт это не переводит) выглядит так:

```
Up to date
Last Sync: 14:32
Files: 1250 of 1250 synced
Errors: 0
```

Вместо `Up to date` может быть `Syncing files...`, `Scanning files...`, `Cleaning up...`, `Sync error` или `Status unknown`, если API не ответил.

Как перейти:

1. Скопируйте [*syncthing_pro.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing_pro.app) в `ext1\applications`. Можно вместо обычного, можно рядом, прописав ещё одну запись в `view.json`.
2. Остановите syncthing и поправьте секцию `gui` в `ext1\applications\syncthing\config.xml`:

```xml
    <gui enabled="true" tls="false" sendBasicAuthPrompt="false">
        <address>/tmp/syncthing.sock</address>
    </gui>
```

3. Останавливайте syncthing только через [*syncthing_kill.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing_kill.app).

> [!WARNING]\
> `syncthing_pro.app` при запуске ставит блокировку, а снимает её только `syncthing_kill.app`. Поэтому останавливайте им. Если остановить иначе (например выключить Wi-Fi), блокировка останется, и следующий тап по `syncthing_pro.app` молча ничего не сделает, пока не перезагрузите устройство. Подробнее в разделе [«Блокировка»](docs/SCRIPTS.md#блокировка).

После этой правки веб-панель по адресу `http://your-ip-address:8384` перестанет открываться, поэтому все папки настройте заранее. Чтобы вернуть панель, верните обратно адрес `0.0.0.0:8384`.

### Синхронизация прогресса чтения
В этой задаче поможет читалка [Koreader](https://github.com/koreader/koreader).

К каждой открытой книге создаётся своя директория с нужными lua-файлами, что даёт возможность чтения между устройствами.

## Не работает?

**Веб-панель не открывается в браузере.** Проверьте, что Wi-Fi включён и компьютер с ридером в одной сети, а адрес именно `http://<IP-ридера>:8384` (без https). С компьютера удобно проверить связь командой `curl http://<IP-ридера>:8384`, а код ошибки виден в браузере по F12 → Network. Если вы перешли на Pro и в `config.xml` стоит адрес `/tmp/syncthing.sock`, панель отключена намеренно, это не сбой.

**Как остановить syncthing и не сажать батарею.** В списке приложений он не виден, потому что работает в фоне. Останавливайте его через [*syncthing_kill.app*](https://github.com/mikedigriz/Syncthing-for-PocketBook/blob/main/syncthing_kill.app) (заодно обновит библиотеку) или перезагрузкой устройства. Wi-Fi включается при старте и выключается при остановке сам, так что в простое сеть батарею не ест.

## Ссылки

[Install Syncthing on PocketBook](https://blog.tastytea.de/posts/syncthing-on-pocketbook/)

[Convert to 8bit bmp icon](https://gist.github.com/mikedigriz/6830eaaedcbba99afbe216c3d9195c06)

Отдельное спасибо [форуму](https://forum.syncthing.net/t/pls-release-a-version-for-pocketbook/21370/) за дополнения!
