
http://squid.diladele.com/
https://slproweb.com/products/Win32OpenSSL.html
https://github.com/WPN-XM/WPN-XM/tree/master/bin/hideconsole
https://3proxy.ru/download/
https://www.torproject.org/download/download.html.en
https://www.henrypp.org/product/chrlauncher

Установка прокси-сервера Squid под Windows (HTTPS + AUFS + ROCK)
Можно я не буду отвечать на вопрос "Зачем?!!" а сразу перейду к описанию? :D

Заранее опишу ограничения:
1. Squid в обязательном порядке требует указывать DNS-сервер. Можно направить его в сторону DNS-сервера на роутере или скормить публичный DNS того же гугла, но лучше поставить Acylic DNS Proxy с настроенным hosts-файлом. Это само по себе, на уровне запросов, блокирует этак 90% рекламы, которую, к тому же, squid в результате не кэширует.
2. Squid не умеет использовать внешние прокси для запросов по https, поэтому делать это придется вручную и довольно корявым образом - с применением Proxifier, в котором надо будет указывать не имена сайтов, на которые хочешь попасть, а их ip-адреса. Поскольку squid не использует системный DNS-резолвер, это единственный вариант, при котором содержимое сайтов будет кэшироваться. Для сайтов TOR можно использовать промежуточный прокси, это я опишу.


Нам потребуется:
1. Собственно, Squid под Windows - берется здесь
2. OpenSSL для генерирования собственного Certificate Authority - берется здесь. Будет достаточно light-пакета на 3Мб
3. Утилита, скрывающая окна консоли качается отсюда.
4. 3proxy, если нужно проксирование в TOR-сеть берется здесь

Начнем же!

1. Распаковываем скачанный пакет - открываем cmd, переходим в папку с пакетом, набираем msiexec /a squid.msi /qb TARGETDIR=.\unpack
2. Копируем папку Squid из unpack в то место, где squid будет работать в дальнейшем. В приведенных мной примерах это папка E:\squid
3. Каталог unpack и squid.msi можно удалить, они больше не понадобятся. Идем в папку E:\squid
4. Открываем cmd.exe в этой папке и вбиваем туда mkdir .\_cache & mkdir .\etc\bump & mkdir .\dev\shm & mkdir .\log & echo 0 > .\log\access.log & echo 0 > .\log\cache.log
Это создает папки для внутренних нужд squid. В дальнейшем предполагается, что кэш располагается в папке _cache
5. Устанавливаем OpenSSL, идем в каталог bin, открываем cmd.exe, вбиваем туда:
5.1 - openssl req -new -config "openssl.cfg" -newkey rsa:1024 -days 1825 -nodes -x509 -keyout squidCA.pem -out squidCA.pem
5.2 - openssl x509 -in squidCA.pem -outform DER -out browserCA.der
Первая команда создает сертификат SquidCA.pem для генерации вторичных сертификатов. Копируем его в E:\squid\etc\bump
Вторая команда конвертирует этот сертификат в формат для импорта в браузер (если Firefox) или систему (если все остальное)
6. Идем в E:\squid\lib\squid, открываем командную строку,
ssl_crtd.exe -c -s /cygdrive/e/squid/etc/bump/ssldb (ВАЖНО: каталога ssldb существовать не должно, иначе вылезет ошибка!)
7. Редактируем E:\squid\etc\squid.conf
У меня он выглядит так:


acl localnet src 10.0.0.0/8 # RFC1918 possible internal network
acl localnet src 172.16.0.0/12 # RFC1918 possible internal network
acl localnet src 192.168.0.0/16 # RFC1918 possible internal network
acl localnet src fc00::/7 # RFC 4193 local private network range
acl localnet src fe80::/10 # RFC 4291 link-local (directly plugged) machines

acl SSL_ports port 443
acl Safe_ports port 80 # http
acl Safe_ports port 21 # ftp
acl Safe_ports port 443 # https
acl Safe_ports port 70 # gopher
acl Safe_ports port 210 # wais
acl Safe_ports port 1025-65535 # unregistered ports
acl Safe_ports port 280 # http-mgmt
acl Safe_ports port 488 # gss-http
acl Safe_ports port 591 # filemaker
acl Safe_ports port 777 # multiling http
acl CONNECT method CONNECT

#
# Recommended minimum Access Permission configuration:
#

# Only allow cachemgr access from localhost
http_access allow localhost manager
http_access deny manager

# Deny requests to certain unsafe ports
# http_access deny !Safe_ports

# Deny CONNECT to other than secure SSL ports
# http_access deny CONNECT !SSL_ports

# We strongly recommend the following be uncommented to protect innocent
# web applications running on the proxy server who think the only
# one who can access services on "localhost" is a local user
# http_access deny to_localhost

#
# INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
#

# Example rule allowing access from your local networks.
# Adapt localnet in the ACL section to list your (internal) IP networks
# from where browsing should be allowed
http_access allow localnet
http_access allow localhost

# And finally deny all other access to this proxy
http_access deny all

# DNS Options
dns_v4_first on
dns_nameservers 127.0.0.1

# Squid normally listens to port 3128
http_port 3128 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=8MB cert=/cygdrive/e/squid/etc/bump/squidCA.pem
sslcrtd_program /cygdrive/e/squid/lib/squid/ssl_crtd -s /cygdrive/e/squid/etc/bump/ssldb -M 8MB
sslcrtd_children 32 startup=2 idle=1
always_direct allow all
ssl_bump client-first all
sslproxy_cert_error allow all
sslproxy_flags DONT_VERIFY_PEER

# LOG
cache_access_log stdio:/cygdrive/e/squid/log/access.log buffer-size=128KB
# cache_store_log stdio:/cygdrive/e/squid/log/store.log buffer-size=128KB
cache_store_log none
cache_log stdio:/cygdrive/e/squid/log/cache.log buffer-size=128KB

# Uncomment the line below to enable disk caching - path format is /cygdrive/, i.e.
cache_dir rock /cygdrive/e/squid/_cache/rock 2048 max-size=32767 max-swap-rate=3000 swap-timeout=300
cache_dir aufs /cygdrive/e/squid/_cache/aufs 4096 16 256 min-size=32768
cache_replacement_policy heap LFUDA
memory_replacement_policy lru
ipcache_size 10240
cache_swap_low 90
cache_swap_high 95
maximum_object_size_in_memory 50 KB
cache_mem 128 MB
memory_pools off
maximum_object_size 4 MB
quick_abort_min -1 KB
log_icp_queries off
client_db off
buffered_logs on
half_closed_clients off
via off
reload_into_ims on
max_filedescriptors 3200
pid_filename /cygdrive/e/squid/_cache/squid.pid
hosts_file none

# Leave coredumps in the first cache dir
coredump_dir /cygdrive/e/squid/_cache

# Add any of your own refresh_pattern entries above these.
# refresh_pattern -i ^ftp: 100000 90% 200000
# refresh_pattern -i ^gopher: 1440 0% 1440

# cache images
refresh_pattern -i \.(gif|png|ico|jpg|jpeg|jp2|webp)$ 259200 90% 518400 override-expire reload-into-ims ignore-no-store ignore-private refresh-ims
refresh_pattern -i \.(jpx|j2k|j2c|fpx|bmp|tif|tiff|bif)$ 259200 90% 20000 override-expire reload-into-ims ignore-no-store ignore-private refresh-ims
refresh_pattern -i \.(pcd|pict|rif|exif|hdr|bpg|img|jif|jfif)$ 259200 90% 518400 override-expire reload-into-ims ignore-no-store ignore-private refresh-ims
refresh_pattern -i \.(woff|woff2|eps|ttf|otf|svg|svgi|svgz|ps|ps1|acsm|eot)$ 259200 90% 518400 override-expire reload-into-ims ignore-no-store ignore-private refresh-ims

# cache content
refresh_pattern -i \.(swf|js|ejs)$ 259200 90% 518400 override-expire reload-into-ims ignore-no-store ignore-private refresh-ims
refresh_pattern -i \.(wav|css|class|dat|zsci|ver|advcs)$ 259200 90% 518400 override-expire reload-into-ims ignore-no-store ignore-private refresh-ims

# cache videos
refresh_pattern -i \.(mpa|m2a|mpe|avi|mov|mpg|mpeg|mpg3|mpg4|mpg5)$ 259200 90% 518400 override-expire reload-into-ims ignore-no-store ignore-private refresh-ims
refresh_pattern -i \.(m1s|mp2v|m2v|m2s|m2ts|wmx|rm|rmvb|3pg|3gpp|omg|ogm|asf|war)$ 259200 90% 518400 override-expire reload-into-ims ignore-no-store ignore-private refresh-ims
refresh_pattern -i \.(asx|mp2|mp3|mp4|mp5|wmv|flv|mts|f4v|f4|pls|midi|mid)$ 259200 90% 518400 override-expire reload-into-ims ignore-no-store ignore-private refresh-ims
refresh_pattern -i \.(htm|html)$ 9440 90% 518400 reload-into-ims ignore-no-store ignore-private refresh-ims
refresh_pattern -i \.(xml|flow|asp|aspx)$ 0 90% 518400 refresh-ims
refresh_pattern -i \.(json)$ 0 90% 518400 refresh-ims
refresh_pattern -i (/cgi-bin/|\?) 0 90% 518400

# live video cache rules
refresh_pattern -i \.(m3u8|ts)$ 0 90% 518400 refresh-ims

# cache microsoft and adobe and other documents
refresh_pattern -i \.(ppt|pptx|doc|docx|docm|docb|dot|pdf|pub|ps)$ 259200 90% 518400 override-expire reload-into-ims ignore-no-store ignore-private refresh-ims
refresh_pattern -i \.(xls|xlsx|xlt|xlm|xlsm|xltm|xlw|csv|txt)$ 259200 90% 518400 override-expire reload-into-ims ignore-no-store ignore-private refresh-ims

refresh_pattern -i . 0 90% 518400 refresh-ims


Я таки нежно напоминаю, что это локальный вариант, для запуска на отдельной машине, с максимальным кэшированием статики. Пути, при необходимости утащить их куда-то в другое место, надо поменять по всему конфигурационному файлу.

8. Создаем ярлык, параметры - C:\Windows\System32\cmd.exe /K "color 02 & cd /dE:\squid\ & set PATH=E:\squid\bin;%PATH%" где нужно указать путь к папке со squid
9. Запускаем этот ярлык (текст в командной строке должен быть зеленым), набираем squid -z
Если все сделано и настроено правильно, то в папке _cache появятся директории aufs и rock. Если где-то накосячено - то читаем E:\squid\log\cache.log и исправляем накосяченное.
10. Открываем cmd.exe, рабочая папка должна быть E:\squid, выполняем icacls .\_cache /T /Q /C /RESET && icacls .\etc\bump /T /Q /C /RESET && icacls .\log /T /Q /C /RESET && pause
Эти команды сбрасывают сбойные права доступа, которые назначает созданным файлам и папкам cygwin. Без выполнения команды rock-кэш работать не будет.
11. Запускаем (из зеленой консоли) squid -N (без этой опции не работает rock-database, увы), выбираем в браузере прокси-сервером 127.0.0.1:3128. Должно работать.
12. Создаем в E:\squid батник для запуска сквида. Имя на ваше усмотрение, содержимое:

cd /d %~dp0
set PATH=%~dp0bin;%PATH%
cd bin
squid -N

Запускаем его.
13. Если все работает как надо, то копируем в папку E:\squid утилиту RunHiddenConsole.exe чтобы в дальнейшем запускать прокси через нее.

Настройка для работы с TOR:

1. Качаем и распаковываем TOR Expert Bundle. Для запуска требуется распаковать его, создать файл torrc.cfg с начинкой
SOCKSPort 127.0.0.1:9050
SOCKSPolicy accept 127.0.0.1
SOCKSPolicy reject *
GeoIPFile .\Data\geoip
GeoIPv6File .\Data\geoip6
DataDirectory .\Data
Ну а далее запускается ярлыком RunHiddenConsole.exe "tor.exe -f torrc.cfg" из папки с TOR'ом.

2. В папке E:\squid создаем файл onion.txt с содержимым
^http.*onion

Аналогичным образом можно добавлять другие сайты (только HTTP), которые должны быть доступны через TOR

3. В файл конфига squid добавляем:
К листам acl
acl onion url_regex "/cygdrive/e/squid/onion.txt"

Перед командой "always_direct" вставляем
cache_peer 127.0.0.1 parent 3127 0 no-query default
never_direct allow onion
always_direct deny onion

4. Скачиваем 3proxy (в архиве), создаем в squid папку _3proxy, копируем туда файл 3proxy.exe из архива
Создаем там же файл 3proxy.cfg с содержимым:

internal 127.0.0.1
fakeresolve
auth iponly
allow * 127.0.0.1
parent 1000 socks5+ 192.168.16.250 9050
proxy -p3127

где 127.0.0.1 9050 - это адрес и порт, на котором слушает TOR (если вы выбрали другой)

5. Переделываем батник запуска squid к виду:
RunHiddenConsole.exe %~dp0_3proxy\3proxy.exe %~dp0_3proxy\3proxy.cfg
cd /d %~dp0
set PATH=%~dp0bin;%PATH%
cd bin
squid -N

Все готово, можно пользоваться. По умолчанию такой режим предназначен только для того, чтобы заходить на сайты находящиеся в доменной зоне .onion

Дополнения:
При включенном squid иметь дисковый кэш браузера включенным как-то излишне.
В Firefox выключаем через about:config, ищем строку browser.cache.disk.enable и ставим ее в false. Кэш в памяти это оставит нетронутым.

В Chromium это делается "извне", путем добавления к ярлыку запуска браузера параметров --disk-cache-size=1 --media-cache-size=1
Поэтому я рекомендую использовать Chromium (и основанные на нем браузеры) не сами по себе, а в портативном виде, с помощью программки chrlauncher, где эти параметры можно задавать в конфигурационном файле.

Если у вас есть ipv6, то опцию dns_v4_first надо переключить в off

И напоследок - ответ на вопрос "а почему бы не использовать HandyCache?"
1. Он не кэширует HTTPS, если его не купить. Лицензия дешевая, и это не проблема, но...
2. Он ломает поведение страниц, которые используют технологию CORS. Это facebook, github, addons.mozilla.org и многих других, о которых я сейчас не вспомню.
3. Поддержка родительских SOCKS в ныне доступной версии RC4 1.0.0.700 сломана.

ИМХО, squid работает быстрее + его способ хранения кэша лично мне нравится больше. Мелкие файлы сохраняются в ROCK-кэш, крупные в AUFS-кэш, пространство на жестком диске (размер кластеров на разделе 32КБ) используется оптимально, по сравнению с HandyCache, где фактический кэш 2,32 Гб у меня занимает 3,86 Гб на диске.

URL: https://rustedowl.livejournal.com/44380.html

