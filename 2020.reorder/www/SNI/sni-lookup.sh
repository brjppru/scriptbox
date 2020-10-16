#/bin/sh

true | openssl s_client -showcerts -connect mail.orionnet.ru:443 2>&1 |
    openssl x509 -text | grep -o 'DNS:[^,]*' | cut -f2 -d:

