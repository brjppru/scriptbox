#!/bin/sh
#
INTERNAL_IP_SRC=192.168.2.1
INTERNAL_IP_DST=192.168.1.1
INTERNAL_IP_MASK=255.255.255.0

EXTERNAL_IP_SRC=X.X.X.X
EXTERNAL_IP_DST=Y.Y.Y.Y

# on remote side change SRC to DST
ARG_SRC=0x10004
ARG_DST=0x10003

# ---------------------------------------------------------------------------- #


ifconfig gif0 destroy
ifconfig gif0 create

gifconfig gif0 "$EXTERNAL_IP_SRC" "$EXTERNAL_IP_DST"
ifconfig gif0 inet "$INTERNAL_IP_SRC" "$INTERNAL_IP_DST" netmask "$INTERNAL_IP_MASK"

setkey -F
setkey -PF

setkey -c <<-EOF

spdadd $INTERNAL_IP_SRC/24 $INTERNAL_IP_DST/24 any -P out ipsec
        esp/tunnel/${EXTERNAL_IP_SRC}-${EXTERNAL_IP_DST}/require;

spdadd $INTERNAL_IP_DST/24 $INTERNAL_IP_SRC/24 any -P in ipsec
        esp/tunnel/${EXTERNAL_IP_DST}-${EXTERNAL_IP_SRC}/require;

add $EXTERNAL_IP_SRC $EXTERNAL_IP_DST esp ${ARG_SRC} -m any
        -E 3des-cbc "XXXXXXXXXXXXXXXXXXXXXXXX";

add $EXTERNAL_IP_DST $EXTERNAL_IP_SRC esp ${ARG_DST} -m any
        -E 3des-cbc "XXXXXXXXXXXXXXXXXXXXXXXX";

EOF

/sbin/route add 192.168.1.0/24 192.168.1.1
