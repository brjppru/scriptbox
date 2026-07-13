# Звуки — источник

Взяты из ICQ-клиента **&RQ** (набор `themes/default/sounds/`).

- **Источник:** `/Users/brjed/Downloads/&RQ`
- **Версия &RQ:** `0.9.7.3` (FileVersion из `&RQ.exe`; ProductName `&RQ`)
- **Файлы** (байт-в-байт с оригиналом, md5 сверен):
  - `msg.wav` — входящее сообщение · `954fbda7ecdb5b74381cba8ea5697ddd`
  - `oncoming.wav` — контакт появился в сети · `a5ecce325d55a03d677fe133d1a0e47b`

## Как подключены (в `../settings.json`)

- `msg.wav` → hook **Notification** (Клод зовёт / просит разрешение)
- `oncoming.wav` → hook **Stop** (ответ готов)
