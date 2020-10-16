Чистка от говн MIUI 8 и CyanogenMod 13 на Xiaomi Redmi 3
Работа админа включает в себя следующие компоненты: 
"Тетрис" (непрерывная бессмысленная борьба с хаосом)
"Сокобан" (как в 4Мб упихать ОС со всем нужным)
"Сапер" (эмпирическим путем найти условия, в которых все работает)

Вот о последнем я и похвастаюсь.
Заказала мне мама телефон новый, ибо старый она нежно и насмерть уронила. Выбор пал на Xiaomi Redmi 3X, по соотношению цена\качество просто офигенная вещь. И уронить не настолько жалко :)
Как оно обычно бывает, в стандартной прошивке лежит просто потрясающее количество говн. В MIUI больше, в CM13 - значительно меньше, но тоже есть.
Методом проб и ошибок была найдена конфигурация, которая позволяет большее количество говн удалить одним махом.
Для удаления понадобится рут и ADB.

Если вы не знаете как ставить программы через ADB, вам лучше вообще не запускать эти скрипты.


echo Сим-сим, откройся!
adb shell "su -c 'mount -o rw,remount /system'"

echo Стандартные приложения
adb shell "su -c 'rm -r /system/priv-app/Browser'"
adb shell "su -c 'rm -r /system/priv-app/Calendar'"
adb shell "su -c 'rm -r /system/priv-app/Music'"
adb shell "su -c 'rm -r /system/app/Email'"
adb shell "su -c 'rm -r /system/app/FileExplorer'"
adb shell "su -c 'rm -r /system/app/Notes'"
adb shell "su -c 'rm -r /system/app/Calculator'"
adb shell "su -c 'rm -r /system/app/FM'"
adb shell "su -c 'rm -r /system/app/SoundRecorder'"
adb shell "su -c 'rm -r /system/app/DeskClock'"

echo Google-говны
adb shell "su -c 'rm -r /system/priv-app/CallLogBackup'"
adb shell "su -c 'rm -r /system/priv-app/BackupRestoreConfirmation'"
adb shell "su -c 'rm -r /system/priv-app/GoogleBackupTransport'"
adb shell "su -c 'rm -r /system/priv-app/GooglePartnerSetup'"
adb shell "su -c 'rm -r /system/priv-app/GoogleOneTimeInitializer'"
adb shell "su -c 'rm -r /system/app/LatinImeGoogle'"
adb shell "su -c 'rm -r /system/app/GoogleTTS'"
adb shell "su -c 'rm -r /system/app/GoogleContactsSyncAdapter'"
adb shell "su -c 'rm -r /system/app/GoogleCalendarSyncAdapter'"
adb shell "su -c 'rm -r /system/app/BackupReceiver'"
adb shell "su -c 'rm -r /system/app/PicoTts'"
adb shell "su -c 'rm -r /system/priv-app/GoogleFeedback'"
adb shell "su -c 'rm -r /system/priv-app/SharedStorageBackup'"

echo MIUI-специфичное
adb shell "su -c 'rm -r /system/priv-app/YellowPage'"
adb shell "su -c 'rm -r /system/app/MiuiVideo'"
adb shell "su -c 'rm -r /system/app/MiuiCompass'"
adb shell "su -c 'rm -r /system/priv-app/MiuiGallery'"
adb shell "su -c 'rm -r /system/priv-app/MiuiCamera'"
adb shell "su -c 'rm -r /system/app/Metok'"
adb shell "su -c 'rm -r /system/app/Stability'"
adb shell "su -c 'rm -r /system/app/QuickSearchBox'"
adb shell "su -c 'rm -r /system/priv-app/CloudBackup'"
adb shell "su -c 'rm -r /system/app/Updater'"
adb shell "su -c 'rm -r /system/app/MiGalleryLockscreen'"
adb shell "su -c 'rm -r /system/app/KingSoftCleaner'"
adb shell "su -c 'rm -r /system/app/CloudService'"
adb shell "su -c 'rm -r /system/app/MiuiScanner'"
adb shell "su -c 'rm -r /system/app/AntiSpam'"
adb shell "su -c 'rm -r /system/priv-app/CleanMaster'"
adb shell "su -c 'rm -r /system/app/BugReport'"
adb shell "su -c 'rm -r /system/app/CameraStability'"
adb shell "su -c 'rm -r /system/app/MiWallpaper'"
adb shell "su -c 'rm -r /system/app/LiveWallpapersPicker'"
adb shell "su -c 'rm -r /system/app/TouchAssistant'"
adb shell "su -c 'rm -r /system/priv-app/FindDevice'"
adb shell "su -c 'rm -r /system/vendor/app/ims'"
adb shell "su -c 'rm -r /system/app/Whetstone'"
adb shell "su -c 'rm -r /system/app/MiPlay'"
adb shell "su -c 'rm -r /system/app/XiaomiAccount'"
adb shell "su -c 'rm -r /system/app/MiLinkService'"
adb shell "su -c 'rm -r /system/app/PaymentService'"
adb shell "su -c 'rm -r /system/priv-app/MiDrop'"
adb shell "su -c 'rm -r /system/app/jjhome'"
adb shell "su -c 'rm -r /system/app/jjstore'"
adb shell "su -c 'rm -r /system/app/jjknowledge'"
adb shell "su -c 'rm -r /system/app/jjcontainer'"
adb shell "su -c 'rm -r /system/priv-app/SecurityCenter'"
adb shell "su -c 'rm -r /system/app/GuardProvider'"
adb shell "su -c 'rm -r /system/app/SecurityAdd'"
adb shell "su -c 'rm -r /system/app/SecurityCoreAdd'"
adb shell "su -c 'rm -r /system/app/com.quicinc.wbcserviceapp'"
adb shell "su -c 'rm -r /system/app/NetworkAssistant2'"
adb shell "su -c 'rm -r /system/app/TranslationService'"
adb shell "su -c 'rm -r /system/app/StepsProvider'"
adb shell "su -c 'rm -r /system/app/KSICibaEngine'"
adb shell "su -c 'rm -r /system/priv-app/Mipub'"
adb shell "su -c 'rm -r /system/priv-app/QtiTetherService'"
adb shell "su -c 'rm -r /system/priv-app/wt_secret_code_manager'"
adb shell "su -c 'rm -r /system/app/uiremoteclient'"

echo Железо-специфичное
adb shell "su -c 'rm -r /system/vendor/app/colorservice'"
adb shell "su -c 'rm -r /system/vendor/app/imssettings'"

echo Прочее, ненужное 
adb shell "su -c 'rm -r /system/priv-app/CellBroadcastReceiver'"
adb shell "su -c 'rm -r /system/app/WfdService'"
adb shell "su -c 'rm -r /system/app/PrintSpooler'"
adb shell "su -c 'rm -r /system/priv-app/Weather'"
adb shell "su -c 'rm -r /system/priv-app/WeatherProvider'"
adb shell "su -c 'rm -r /system/app/Stk'"
adb shell "su -c 'rm -r /system/priv-app/Backup'"
adb shell "su -c 'rm -r /system/priv-app/WallpaperCropper'"
adb shell "su -c 'rm -r /system/priv-app/ConfigUpdater'"

echo Морозим!
adb shell "su -c 'pm disable com.android.documentsui'"

echo Именем администратора, ребутъ!
adb shell "su -c 'reboot'"



echo Сим-сим, откройся!
adb shell "su -c 'mount -o rw,remount /system'"

echo Заставки и обои
adb shell "su -c 'rm -r /system/app/PhotoTable'"
adb shell "su -c 'rm -r /system/app/NoiseField'"
adb shell "su -c 'rm -r /system/app/LiveWallpapers'"
adb shell "su -c 'rm -r /system/app/WallpaperPicker'"
adb shell "su -c 'rm -r /system/app/LiveWallpapersPicker'"
adb shell "su -c 'rm -r /system/app/HoloSpiralWallpaper'"
adb shell "su -c 'rm -r /system/app/PhotoPhase'"
adb shell "su -c 'rm -r /system/app/Galaxy4'"
adb shell "su -c 'rm -r /system/app/PhaseBeam'"
adb shell "su -c 'rm -r /system/app/BasicDreams'"
adb shell "su -c 'rm -r /system/app/CMWallpapers'"

echo Стандартные приложения
adb shell "su -c 'rm -r /system/app/Browser'"
adb shell "su -c 'rm -r /system/app/Eleven'"
adb shell "su -c 'rm -r /system/app/Email'"
adb shell "su -c 'rm -r /system/app/Gallery2'"
adb shell "su -c 'rm -r /system/app/Calendar'"
adb shell "su -c 'rm -r /system/app/FM2'"
adb shell "su -c 'rm -r /system/app/SoundRecorder'"
adb shell "su -c 'rm -r /system/app/CMFileManager'"
adb shell "su -c 'rm -r /system/app/ExactCalculator'"
adb shell "su -c 'rm -r /system/priv-app/Snap'"

echo Google-говны
adb shell "su -c 'rm -r /system/app/LatinIME'"
adb shell "su -c 'rm -r /system/app/PrintSpooler'"
adb shell "su -c 'rm -r /system/app/PicoTts'"
adb shell "su -c 'rm -r /system/app/GoogleTTS'"
adb shell "su -c 'rm -r /system/app/GoogleContactsSyncAdapter'"
adb shell "su -c 'rm -r /system/app/GoogleCalendarSyncAdapter'"
adb shell "su -c 'rm -r /system/priv-app/GoogleFeedback'"
adb shell "su -c 'rm -r /system/priv-app/GoogleBackupTransport'"
adb shell "su -c 'rm -r /system/priv-app/GooglePartnerSetup'"
adb shell "su -c 'rm -r /system/priv-app/CallLogBackup'"
adb shell "su -c 'rm -r /system/priv-app/BackupRestoreConfirmation'"
adb shell "su -c 'rm -r /system/priv-app/SharedStorageBackup'"
adb shell "su -c 'rm -r /system/priv-app/GoogleOneTimeInitializer'"

echo Китайские говны
adb shell "su -c 'rm -r /system/app/tadu'"
adb shell "su -c 'rm -r /system/app/wandoujia'"
adb shell "su -c 'rm -r /system/app/baidubrowser'"
adb shell "su -c 'rm -r /system/app/BaiduMap'"

echo Cyanogen-специфичное
adb shell "su -c 'rm -r /system/priv-app/CyanogenSetupWizard'"
adb shell "su -c 'rm -r /system/priv-app/CMUpdater'"
adb shell "su -c 'rm -r /system/priv-app/ThemesProvider'"
adb shell "su -c 'rm -r /system/priv-app/WeatherManagerService'"
adb shell "su -c 'rm -r /system/priv-app/LiveLockScreenService'"
adb shell "su -c 'rm -r /system/priv-app/ThemeManagerService'"
adb shell "su -c 'rm -r /system/priv-app/WeatherProvider'"
adb shell "su -c 'rm -r /system/priv-app/ThemeChooser'"
adb shell "su -c 'rm -r /system/priv-app/Screencast'"
adb shell "su -c 'rm -r /system/priv-app/HexoLibre'"

echo Прочее, ненужное 
adb shell "su -c 'rm -r /system/app/Stk'"
adb shell "su -c 'rm -r /system/app/NewsArticle'"
adb shell "su -c 'rm -r /system/app/Exchange2'"
adb shell "su -c 'rm -r /system/app/LockClock'"
adb shell "su -c 'rm -r /system/app/ConfigUpdater'"
adb shell "su -c 'rm -r /system/app/SetupWizard'"
adb shell "su -c 'rm -r /system/app/statservice'"
adb shell "su -c 'rm -r /system/priv-app/CellBroadcastReceiver'"

echo Морозим!
adb shell "su -c 'pm disable com.android.documentsui'"

echo Именем администратора, ребутъ!
adb shell "su -c 'reboot'"


UPD: проблема с отключением радиомодуля через некоторое время после перезагрузки в прошивке MIUI8 решена. Более фатальных багов не наблюдается.

Особо отмечу, что это "мягкий вариант", не удаляющий полностью Google Apps, что для лично своих телефонов я никогда не делаю. Здесь работает GCM (push-уведомления) и Play Market, но разнообразные синхронизации и бэкапции убиты.


https://rustedowl.livejournal.com/38499.html

