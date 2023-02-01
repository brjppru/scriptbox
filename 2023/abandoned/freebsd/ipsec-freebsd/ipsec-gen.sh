#!/bin/sh

# brj ipsec transport tunnel generator script, http://brj.pp.ru/

IP1="89.105.128.222"
IP2="195.112.250.27"

HOST1="ipsec.conf.for.${IP1}.host"
HOST2="ipsec.conf.for.${IP2}.host"

PASS1=`apg -m 16 -n 1`
PASS2=`apg -m 16 -n 1`

# generate settings for host1
echo "add ${IP2} ${IP1} esp 9997 -E rijndael-cbc \"${PASS1}\";" > ${HOST1}
echo "add ${IP1} ${IP2} esp 9998 -E rijndael-cbc \"${PASS2}\";" >> ${HOST1}
echo "spdadd ${IP1} ${IP2} any -P out ipsec esp/transport/${IP1}-${IP2}/require;" >> ${HOST1}
echo "spdadd ${IP2} ${IP1} any -P in  ipsec esp/transport/${IP2}-${IP1}/require;" >> ${HOST1}

# generate settings for host2
echo "add ${IP2} ${IP1} esp 9997 -E rijndael-cbc \"${PASS1}\";" > ${HOST2}
echo "add ${IP1} ${IP2} esp 9998 -E rijndael-cbc \"${PASS2}\";" >> ${HOST2}
echo "spdadd ${IP2} ${IP1} any -P out ipsec esp/transport/${IP2}-${IP1}/require;" >> ${HOST2}
echo "spdadd ${IP1} ${IP2} any -P in  ipsec esp/transport/${IP1}-${IP2}/require;" >> ${HOST2}

echo "all done. happy crypting ;-) wbr, brj. http://brj.pp.ru/"
