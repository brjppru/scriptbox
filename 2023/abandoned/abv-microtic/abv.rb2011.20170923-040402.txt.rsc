# sep/23/2017 04:04:03 by RouterOS 6.36
# software id = KUFK-IS7X
#
/interface ethernet
set [ find default-name=ether4 ] disabled=yes
set [ find default-name=ether5 ] disabled=yes
set [ find default-name=ether6 ] disabled=yes
set [ find default-name=ether7 ] disabled=yes
set [ find default-name=ether8 ] disabled=yes
set [ find default-name=ether9 ] disabled=yes
set [ find default-name=ether10 ] name=lan-ABV poe-out=off
set [ find default-name=sfp1 ] disabled=yes
set [ find default-name=ether3 ] disabled=yes name=vip-net
set [ find default-name=ether1 ] name=wan-APG
set [ find default-name=ether2 ] name=wan-RTK
/interface gre
add !keepalive mtu=1476 name=GRE-brj remote-address=1.1.1.1
/ip neighbor discovery
set ether4 discover=no
set ether5 discover=no
set ether6 discover=no
set ether7 discover=no
set ether8 discover=no
set ether9 discover=no
set sfp1 discover=no
set wan-APG discover=no
set wan-RTK discover=no
/ip dhcp-server
add add-arp=yes always-broadcast=yes disabled=no interface=lan-ABV \
    lease-time=1h name=abv-dhcp
/ip pool
add name=abv-dhcp ranges=10.10.24.200-10.10.24.205
/ip firewall connection tracking
set tcp-established-timeout=1h
/ip address
add address=10.10.24.10/24 comment="abv clt" interface=lan-ABV network=\
    10.10.24.0
add address=91.194.173.67/28 comment="sip telecom" interface=wan-APG network=\
    91.194.173.64
add address=95.156.82.162/29 comment="rostelekom /29" interface=wan-RTK \
    network=95.156.82.160
add address=192.168.20.5/30 comment="GRE tunnel to brj" interface=GRE-brj \
    network=192.168.20.4
add address=10.135.0.2/24 comment="vipnet routing" disabled=yes interface=\
    vip-net network=10.135.0.0
/ip dhcp-client
add dhcp-options=hostname,clientid interface=wan-APG
/ip dhcp-server lease
add address=10.10.24.10 always-broadcast=yes comment="pfsense pfsense " \
    mac-address=00:0C:29:45:E1:27
add address=10.10.24.11 always-broadcast=yes comment="esxi esxi " \
    mac-address=00:8C:FA:C8:4D:80
add address=10.10.24.14 always-broadcast=yes comment="qnap qnap storage " \
    mac-address=00:08:9B:F0:3C:3E
add address=10.10.24.15 always-broadcast=yes comment="1C 1C server " \
    mac-address=00:0C:29:62:40:2B
add address=10.10.24.18 always-broadcast=yes comment=\
    "lab2-hp lab2-hp server " mac-address=28:80:23:A1:C7:84
add address=10.10.24.19 always-broadcast=yes comment=\
    "lab2-ilo LAB2 ilo in rack " mac-address=12:13:14:15:16:04
add address=10.10.24.20 always-broadcast=yes comment="ats ATS " mac-address=\
    08:00:23:37:4E:2A
add address=10.10.24.21 always-broadcast=yes comment="ats-e1 ats trunk1 " \
    mac-address=08:00:23:37:4E:2B
add address=10.10.24.22 always-broadcast=yes comment="ats-e2 ats trunk2 " \
    mac-address=08:00:23:37:4E:2C
add address=10.10.24.30 always-broadcast=yes comment="moxa-au680 moxa-au680 " \
    mac-address=00:90:E8:34:27:D3
add address=10.10.24.31 always-broadcast=yes comment=\
    "moxa-au5800 moxa-au5800 " mac-address=00:90:E8:4D:7A:D9
add address=10.10.24.32 always-broadcast=yes comment=\
    "moxa-ir200l moxa-ir200l " mac-address=00:90:E8:4D:7A:C3
add address=10.10.24.33 always-broadcast=yes comment=\
    "moxa-ir200r moxa-ir200r " mac-address=00:90:E8:4D:7B:32
add address=10.10.24.34 always-broadcast=yes comment=\
    "moxa-evolis moxa-evolis " mac-address=00:90:E8:4D:7A:A6
add address=10.10.24.35 always-broadcast=yes comment=\
    "moxa-roller moxa-roller " mac-address=00:90:E8:4D:7A:AB
add address=10.10.24.36 always-broadcast=yes comment=\
    "moxa-alifax1 moxa-alifax1 " mac-address=00:90:E8:4D:7A:AF
add address=10.10.24.37 always-broadcast=yes comment="brj Roman Y. Bogdanov " \
    mac-address=D8:CB:8A:B3:5D:D7
add address=10.10.24.38 always-broadcast=yes comment=\
    "moxa-alifax2 moxa-alifax2 " mac-address=00:90:E8:4E:5B:05
add address=10.10.24.39 always-broadcast=yes comment=\
    "moxa-alifax3 moxa-alifax3 " mac-address=00:90:E8:4E:5B:0B
add address=10.10.24.50 always-broadcast=yes comment=\
    "skorohod Skorohodova TG " mac-address=B8:AE:ED:D1:93:74
add address=10.10.24.51 always-broadcast=yes comment=\
    "rm Romanchenko Alexander " mac-address=D8:CB:8A:B3:60:2A
add address=10.10.24.52 always-broadcast=yes comment="polina Korsun Polina " \
    mac-address=D8:CB:8A:B3:60:2E
add address=10.10.24.53 always-broadcast=yes comment="petra Petrachenko " \
    mac-address=D8:CB:8A:B3:60:2B
add address=10.10.24.54 always-broadcast=yes comment="kyocera kyocera in 36 " \
    mac-address=00:17:C8:04:73:DC
add address=10.10.24.56 always-broadcast=yes comment="matus S.G. " \
    mac-address=D8:CB:8A:B3:5F:60
add address=10.10.24.57 always-broadcast=yes comment="pcr22 PCR + anal " \
    mac-address=D8:CB:8A:B3:5D:7E
add address=10.10.24.58 always-broadcast=yes comment="pcr1 pcr no anal " \
    mac-address=40:8D:5C:2C:E6:7A
add address=10.10.24.59 always-broadcast=yes comment=\
    "buhprint buh olga print " mac-address=60:02:92:4E:68:26
add address=10.10.24.60 always-broadcast=yes comment=\
    "olgaprint buh olga nout print " mac-address=3C:A8:2A:F9:2A:CC
add address=10.10.24.61 always-broadcast=yes comment=\
    "labsort lab sorter comp " mac-address=D8:CB:8A:B3:60:23
add address=10.10.24.62 always-broadcast=yes comment="sorter sorter 2500 " \
    mac-address=00:01:29:62:1A:DA
add address=10.10.24.63 always-broadcast=yes comment="itprint itprint " \
    mac-address=58:20:B1:53:34:81
add address=10.10.24.64 always-broadcast=yes comment="lab28 lab28 - kto eto " \
    mac-address=D8:CB:8A:B3:60:22
add address=10.10.24.65 always-broadcast=yes comment="arc2000 arc2000 " \
    mac-address=90:E2:BA:A5:4F:A4
add address=10.10.24.66 always-broadcast=yes comment="vipnet vipnet " \
    mac-address=10:10:10:20:30:20
add address=10.10.24.67 always-broadcast=yes comment="vipclient vipclient " \
    mac-address=10:10:10:20:30:21
add address=10.10.24.68 always-broadcast=yes comment="zebra zebra " \
    mac-address=D8:CB:8A:B3:60:34
add address=10.10.24.69 always-broadcast=yes comment="pcrprint pcrprint " \
    mac-address=58:20:B1:52:27:70
add address=10.10.24.70 always-broadcast=yes comment=\
    "color-print color-print " mac-address=34:64:A9:96:C8:21
add address=10.10.24.71 always-broadcast=yes comment="karpov karpov " \
    mac-address=F0:76:1C:31:1D:0D
add address=10.10.24.72 always-broadcast=yes comment="olgap olga p nastol " \
    mac-address=50:7B:9D:B0:CF:B1
add address=10.10.24.73 always-broadcast=yes comment=\
    "printolga olga p. print " mac-address=FC:3F:DB:C1:9C:0A
add address=10.10.24.74 always-broadcast=yes comment="stat-01 stat-01 " \
    mac-address=D8:CB:8A:B3:60:1F
add address=10.10.24.75 always-broadcast=yes comment=\
    "polinaprint polinaprint " mac-address=58:20:B1:52:77:DC
add address=10.10.24.76 always-broadcast=yes comment=pcr-gp mac-address=\
    94:DE:80:DF:74:6C
add address=10.10.24.77 always-broadcast=yes comment="brjap brjap " \
    mac-address=2C:60:0C:E7:FD:20
add address=10.10.24.78 always-broadcast=yes comment="au680-inet au680-inet " \
    mac-address=00:19:0F:24:C5:A1
add address=10.10.24.79 always-broadcast=yes comment="brjfox2 brjfox2 " \
    mac-address=FC:3D:93:75:0B:FB
add address=10.10.24.80 always-broadcast=yes comment=sip122 mac-address=\
    08:00:23:A8:00:2F
add address=10.10.24.81 always-broadcast=yes comment=sip123 mac-address=\
    08:00:23:A8:00:2E
add address=10.10.24.82 always-broadcast=yes comment=sip126 mac-address=\
    08:00:23:A8:00:2C
add address=10.10.24.83 always-broadcast=yes comment=sip127 mac-address=\
    08:00:23:A8:00:4C
add address=10.10.24.84 always-broadcast=yes comment=sip125 mac-address=\
    08:00:23:A8:00:4B
add address=10.10.24.85 always-broadcast=yes comment=sip116 mac-address=\
    08:00:23:A8:00:4A
add address=10.10.24.86 always-broadcast=yes comment=sip131 mac-address=\
    08:00:23:A8:00:43
add address=10.10.24.87 always-broadcast=yes comment=sip132 mac-address=\
    08:00:23:A8:00:41
add address=10.10.24.88 always-broadcast=yes comment=sip124 mac-address=\
    08:00:23:A8:00:40
add address=10.10.24.89 always-broadcast=yes comment=sip111 mac-address=\
    08:00:23:A8:00:C2
add address=10.10.24.90 always-broadcast=yes comment=sip112 mac-address=\
    08:00:23:A8:00:C0
add address=10.10.24.91 always-broadcast=yes comment=sip113 mac-address=\
    08:00:23:A8:00:C1
add address=10.10.24.92 always-broadcast=yes comment=sip114 mac-address=\
    08:00:23:A7:FF:F3
add address=10.10.24.93 always-broadcast=yes comment=sip115 mac-address=\
    08:00:23:A7:FF:F1
add address=10.10.24.94 always-broadcast=yes comment=sip121 mac-address=\
    08:00:23:A7:FF:F2
add address=10.10.24.95 always-broadcast=yes comment=\
    "dianov-book dianov-book " mac-address=68:F7:28:50:3B:21
add address=10.10.24.96 always-broadcast=yes comment="clinica clinica " \
    mac-address=D8:CB:8A:B3:60:3D
add address=10.10.24.97 always-broadcast=yes comment=del-iris mac-address=\
    00:19:0F:25:FB:7D
add address=10.10.24.98 always-broadcast=yes comment=\
    "immunologia immunologia " mac-address=D8:CB:8A:B3:60:1C
add address=10.10.24.99 always-broadcast=yes comment="test-test test-test " \
    mac-address=00:01:02:03:02:02
add address=10.10.24.100 always-broadcast=yes comment=\
    "hozyayka hozyayka Irina " mac-address=D8:CB:8A:B3:60:3C
add address=10.10.24.101 always-broadcast=yes comment=hematology mac-address=\
    D8:CB:8A:B3:5F:89
add address=10.10.24.102 always-broadcast=yes comment="lab28-2 lab28-2 " \
    mac-address=D8:CB:8A:B3:5E:EC
add address=10.10.24.103 always-broadcast=yes comment="video video net " \
    mac-address=C8:3A:35:09:0E:D0
add address=10.10.24.104 always-broadcast=yes comment="reg-04 reg-04 " \
    mac-address=D8:CB:8A:B3:5F:4D
add address=10.10.24.105 always-broadcast=yes comment="reg-01 reg-01 " \
    mac-address=D8:CB:8A:B3:60:3B
add address=10.10.24.106 always-broadcast=yes comment=\
    "HP-M604-reg-left print-HP-M604-reg-left " mac-address=FC:3F:DB:BD:78:CD
add address=10.10.24.107 always-broadcast=yes comment="reg-03 reg-03 " \
    mac-address=D8:CB:8A:B3:5F:B2
add address=10.10.24.108 always-broadcast=yes comment="reg-02 reg-02 " \
    mac-address=D8:CB:8A:B3:60:38
add address=10.10.24.109 always-broadcast=yes comment="reg-05 reg-05 " \
    mac-address=D8:CB:8A:B3:60:31
add address=10.10.24.110 always-broadcast=yes comment="gemostaz gemostaz " \
    mac-address=D8:CB:8A:B3:60:28
add address=10.10.24.111 always-broadcast=yes comment="kadri kadri " \
    mac-address=50:7B:9D:B3:0A:18
add address=10.10.24.112 always-broadcast=yes comment=\
    "pcr-notebook pcr-notebook" mac-address=3C:97:0E:DC:4D:DC
add address=10.10.24.16 always-broadcast=yes comment="esxi2 esxi2 " \
    mac-address=40:A8:F0:2F:4F:4C
add address=10.10.24.23 always-broadcast=yes comment="cache2 cache2 " \
    mac-address=50:7B:9D:B3:04:4B
add address=10.10.24.24 always-broadcast=yes comment="ubunta ubunta " \
    mac-address=00:0C:29:AB:BA:06
add address=10.10.24.40 always-broadcast=yes comment="moxa-arx moxa-arx " \
    mac-address=00:90:E8:4D:7A:93
add address=10.10.24.41 always-broadcast=yes comment="moxa-myla moxa-myla " \
    mac-address=00:90:E8:4E:5B:38
add address=10.10.24.42 always-broadcast=yes comment=\
    "moxa-adagio moxa-adagio " mac-address=00:90:E8:4D:7A:9F
add address=10.10.24.43 always-broadcast=yes comment="moxa-bact moxa-bact " \
    mac-address=00:90:E8:4D:7B:3A
add address=10.10.24.44 always-broadcast=yes comment=\
    "moxa-immulate moxa-immulate " mac-address=00:90:E8:4D:7A:B3
add address=10.10.24.113 always-broadcast=yes comment=pol-left mac-address=\
    D8:CB:8A:B3:5C:21
add address=10.10.24.114 always-broadcast=yes comment=pol-right mac-address=\
    50:7B:9D:B0:D9:4A
add address=10.10.24.115 always-broadcast=yes comment="right tanya-right " \
    mac-address=50:7B:9D:B0:D0:C7
add address=10.10.24.116 always-broadcast=yes comment=\
    "sysmex5100 sysmex cs-5100 " mac-address=A0:36:9F:78:BC:8E
add address=10.10.24.117 always-broadcast=yes comment="biolog biolog " \
    mac-address=D8:CB:8A:B3:59:A9
add address=10.10.24.118 always-broadcast=yes comment="hoz hoz " mac-address=\
    50:7B:9D:B0:CC:1A
add address=10.10.24.119 always-broadcast=yes comment="reg-06 reg-06 " \
    mac-address=50:7B:9D:B3:04:4F
add address=10.10.24.120 always-broadcast=yes comment=\
    "sysmex-left sysmex-left " mac-address=EC:B1:D7:32:35:B6
add address=10.10.24.121 always-broadcast=yes comment=\
    "sysmex-right sysmex-right " mac-address=EC:B1:D7:3B:B5:01
add address=10.10.24.125 always-broadcast=yes comment="golicova golicova " \
    mac-address=14:DA:E9:40:E3:0E
add address=10.10.24.126 always-broadcast=yes comment="sparmigor sparmigor " \
    mac-address=54:53:ED:AE:EA:2D
add address=10.10.24.127 always-broadcast=yes comment=\
    "bataeva_notebook bataeva_notebook " mac-address=40:61:86:BA:21:E4
add address=10.10.24.128 always-broadcast=yes comment=\
    "microbiologiya microbiologiya " mac-address=34:64:A9:2A:3A:0D
add address=10.10.24.129 always-broadcast=yes comment="micro2 micro2 " \
    mac-address=50:7B:9D:B3:0B:7D
add address=10.10.24.130 always-broadcast=yes comment="immulate immulate " \
    mac-address=01:02:03:04:08:08
add address=10.10.24.131 always-broadcast=yes comment=\
    "Administrator Administrator " mac-address=50:7B:9D:B3:08:A5
add address=10.10.24.132 always-broadcast=yes comment=\
    "microbiolog-01 microbiolog-01 " mac-address=50:7B:9D:B0:D4:DB
add address=10.10.24.133 always-broadcast=yes comment=\
    "immunologia-02 immunologia-02 " mac-address=50:7B:9D:B3:04:4A
add address=10.10.24.134 always-broadcast=yes comment=\
    "HP-M604-reg-right print-HP-M604-reg-right " mac-address=\
    FC:3F:DB:BD:38:A8
add address=10.10.24.135 always-broadcast=yes comment="reg-07 reg-07 " \
    mac-address=D8:CB:8A:B3:60:36
add address=10.10.24.136 always-broadcast=yes comment=\
    "microhp microhp print " mac-address=58:20:B1:52:77:E9
add address=10.10.24.137 always-broadcast=yes comment="liswork liswork cab " \
    mac-address=D8:CB:8A:B3:5F:C9
add address=10.10.24.138 always-broadcast=yes comment=\
    "temp-delete temp-delete " mac-address=40:B0:34:01:CB:47
add address=10.10.24.139 always-broadcast=yes comment=\
    "pay-terminal pay-terminal " mac-address=54:7F:54:E4:96:AD
add address=10.10.24.140 always-broadcast=yes comment="adagio adagio " \
    mac-address=EC:08:6B:05:D7:C2
add address=10.10.24.141 always-broadcast=yes comment=\
    "microscopiya-03 microscopiya-03 " mac-address=D8:CB:8A:B3:5F:64
add address=10.10.24.142 always-broadcast=yes comment=\
    "Microscopiya-01 Microscopiya-01 " mac-address=D8:CB:8A:B3:5E:F5
add address=10.10.24.143 always-broadcast=yes comment="kal kal " mac-address=\
    D8:CB:8A:B3:5C:C9
add address=10.10.24.144 always-broadcast=yes comment=\
    "Microscopiya-02 Microscopiya-02 " mac-address=D8:CB:8A:B3:60:29
add address=10.10.24.145 always-broadcast=yes comment=\
    "Administrator-2 Administrator-2 " mac-address=50:7B:9D:B3:0A:A4
add address=10.10.24.146 always-broadcast=yes comment="priem priem probirok " \
    mac-address=D8:CB:8A:B3:60:32
add address=10.10.24.148 always-broadcast=yes comment=\
    "HPnotebook17 HPnotebook17 " mac-address=EC:8E:B5:34:66:6A
add address=10.10.24.149 always-broadcast=yes comment=\
    "skorohoda skorohod PC biliayrd " mac-address=D4:3D:7E:27:A8:3A
add address=10.10.24.150 always-broadcast=yes comment="kyokomm kyokomm " \
    mac-address=00:17:C8:23:0E:1C
add address=10.10.24.151 always-broadcast=yes comment=temp-del mac-address=\
    BC:AD:28:7A:2D:01
add address=10.10.24.152 always-broadcast=yes comment="ip_cam ip_cam " \
    mac-address=A4:14:37:E5:1E:E4
add address=10.10.24.153 always-broadcast=yes comment="printstat printstat " \
    mac-address=58:20:B1:52:37:0C
add address=10.10.24.154 always-broadcast=yes comment=\
    "HPnotebook17-2 HPnotebook17-2 " mac-address=30:E1:71:29:40:3D
add address=10.10.24.155 always-broadcast=yes comment="mb mb clinika " \
    mac-address=F4:4D:30:A2:C5:D4
add address=10.10.24.156 always-broadcast=yes comment="1c-guest 1c-guest " \
    mac-address=C8:5B:76:21:3E:B0
add address=10.10.24.157 always-broadcast=yes comment=\
    "HPnotebook17-3 HPnotebook17-3 ekaterina " mac-address=30:E1:71:29:40:D7
add address=10.10.24.158 always-broadcast=yes comment="sip-t1 sip-t1 " \
    mac-address=08:00:23:E2:26:02
add address=10.10.24.159 always-broadcast=yes comment="sip12 sip12 " \
    mac-address=08:00:23:E2:21:99
add address=10.10.24.160 always-broadcast=yes comment="sip4 sip4 " \
    mac-address=08:00:23:E2:26:26
add address=10.10.24.161 always-broadcast=yes comment="mobilon mobilon " \
    mac-address=E8:11:32:8E:68:FD
add address=10.10.24.162 always-broadcast=yes comment="evolis evolis " \
    mac-address=8C:DC:D4:4D:6C:40
add address=10.10.24.163 always-broadcast=yes comment="stepasha stepasha " \
    mac-address=30:E1:71:29:53:75
add address=10.10.24.164 always-broadcast=yes comment="note2 note2" \
    mac-address=40:B0:34:01:6B:99
/ip dhcp-server network
add address=10.10.24.0/24 dns-server=10.10.24.10 domain=abv.clt gateway=\
    10.10.24.10 netmask=24 ntp-server=10.10.24.10
/ip dns
set allow-remote-requests=yes cache-max-ttl=30m servers=77.88.8.88,77.88.8.2
/ip dns static
add address=10.10.24.10 name=ix.abv.clt
add address=10.10.24.9 name=ix.abv.clt
add address=91.194.173.65 name=apg-wan.ctl.abv
add address=95.156.82.161 name=rtk-wan.abv.clt
add address=10.10.24.12 name=cabinet.clt-lab.ru
add address=185.76.144.228 name=clt-lab.ru
add address=185.76.144.228 name=www.clt-lab.ru
/ip firewall address-list
add address=1.1.1.1 comment=brj.home list=WINBOX
add address=109.195.67.183 comment="fireball home RDP" list=WINBOX
add address=195.208.166.6 comment="fireball work winbox" list=WINBOX
add address=10.10.24.0/24 comment="LAN network" list=LAN
add address=1.1.1.1 comment=brj.home list=GRE
add address=192.168.20.6 comment="brj home IX" list=WINBOX
add address=77.88.8.2 comment="yandex.safe dns" list=YADNS
add address=77.88.8.88 comment="yandex.safe dns" list=YADNS
add address=94.72.41.80/28 comment="sparm network" list=sparm
add address=217.15.60.244 comment="lipatov 1c" list=lipatov
add address=46.166.88.124 comment="9 \EC\E0\FF" list=sparm
add address=46.166.88.16 comment="9 \EC\E0\FF" list=sparm
add address=46.182.129.185 comment="9 \EC\E0\FF" list=sparm
add address=5.18.188.3 comment=\
    "\F1\EF\E0\F0\EC \E2\ED\E5\F8\ED\E8\E9 \F0\E0\E7\F0\E0\E1\EE\F2\F7\E8\EA" \
    list=sparm
add address=95.80.82.106 comment=\
    "\F1\EF\E0\F0\EC \E2\ED\E5\F8\ED\E8\E9 \F0\E0\E7\F0\E0\E1\EE\F2\F7\E8\EA" \
    list=sparm
add address=46.182.129.172 comment=\
    "\C0\E4\F0\E5\F1 \EE\F4\E8\F1\E0 \ED\E0 \EC\E8\F0\E0 46.182.129.172" \
    list=sparm
add address=46.182.129.171 comment="\CA\EE\EF\FB\EB\EE\E2\E0 46.182.129.171" \
    list=sparm
add address=46.182.131.236 comment="78\E4\E1 46.182.131.236" list=sparm
add address=213.87.121.68 comment="\EF\F0\EE\F1\EA\EE\E2\FC\FF 213.87.121.24" \
    list=sparm
add address=217.15.60.209 comment=anohin list=lipatov
add address=213.87.224.156 comment="\EF\F0\EE\F1\EA\EE\E2\FC\FF" list=sparm
add address=195.130.214.180 comment=naiblom! list=WINBOX
add address=213.87.123.145 comment="\EF\F0\EE\F1\EA\EE\E2\FC\FF" list=sparm
add address=94.73.245.85 comment="\E3\EE\E2\EE\F0\EE\E2\E0" list=sparm
add address=213.87.225.118 comment="\EF\F0\EE\F1\EA\EE\E2\FC\FF" list=sparm
add address=213.87.224.112 comment="\EF\F0\EE\F1\EA\EE\E2\FC\FF" list=sparm
add address=213.87.122.231 comment="\EF\F0\EE\F1\EA\EE\E2\FC\FF" list=sparm
add address=1.1.1.1 comment="\EF\F0\EE\F1\EA\EE\E2\FC\FF" list=sparm
add address=213.87.123.113 comment="\EF\F0\EE\F1\EA\EE\E2\FC\FF" list=sparm
add address=213.87.225.48 comment="\EF\F0\EE\F1\EA\EE\E2\FC\FF" list=sparm
add address=213.87.127.10 comment="\EF\F0\EE\F1\EA\EE\E2\FC\FF" list=sparm
add address=213.87.127.11 comment=proskovia list=sparm
add address=213.87.127.60 comment=proskoviya list=sparm
add address=213.87.120.106 comment="\EF\F0\EE\F1\EA\EE\E2\FC\FF" list=sparm
add address=91.211.56.247 comment=nazarovo list=sparm
add address=213.87.255.111 comment=prosk list=sparm
add address=213.87.225.111 comment=paroskoviya list=sparm
add address=213.87.126.50 comment="\EF\F0\EE\F1\EA\EE\E2\FC\FF" list=sparm
add address=217.117.188.210 comment=naiblom! list=WINBOX
add address=95.72.22.141 comment="\E0\ED\E4\F0\E5\E9 1\F1 \E4\EE\EC" list=\
    lipatov
add address=77.240.174.174 comment=Telmana list=sparm
/ip firewall filter
add action=fasttrack-connection chain=forward connection-state=\
    established,related log-prefix=""
add action=drop chain=input comment="block torrent" disabled=yes log-prefix=\
    "" src-address=10.10.24.141
add action=accept chain=input comment="forward sparm cabinet to any" \
    dst-port=1337 log=yes log-prefix="" protocol=tcp
add action=accept chain=forward comment="forward sparm cabinet to any" log=\
    yes log-prefix="" protocol=tcp src-address=10.10.24.12 src-port=1337
add action=drop chain=forward comment="Drop all INVALID #1" connection-state=\
    invalid log=yes log-prefix=""
add action=drop chain=input comment="Drop all INVALID #2" connection-state=\
    invalid log=yes log-prefix=""
add action=accept chain=input comment="Allow all ESTABLISHED & RELATED" \
    connection-state=established,related log-prefix=""
add action=accept chain=forward comment="Allow all ESTABLISHED & RELATED" \
    connection-state=established,related log-prefix=""
add action=accept chain=input comment="Allow GRE for Address List" \
    log-prefix="" protocol=gre src-address-list=GRE
add action=accept chain=forward comment="Allow GRE for Address List" \
    log-prefix="" protocol=gre src-address-list=GRE
add action=accept chain=output comment="Allow GRE for Address List" \
    log-prefix="" protocol=gre src-address-list=GRE
add action=accept chain=forward comment="Allow GRE <->" in-interface=GRE-brj \
    log-prefix=""
add action=accept chain=input comment="Allow GRE <->" in-interface=GRE-brj \
    log-prefix=""
add action=accept chain=output comment="Allow GRE <->" log-prefix="" \
    out-interface=GRE-brj
add action=accept chain=input comment="Allow Winbox from Address List" \
    dst-port=8291 log-prefix="" protocol=tcp src-address-list=WINBOX
add action=accept chain=input comment="Allow DNS from LAN" dst-port=53 \
    in-interface=lan-ABV limit=50,5:packet log-prefix="" protocol=udp
add action=accept chain=input comment="Allow SSH from Address List" dst-port=\
    22 log-prefix="" protocol=tcp src-address-list=WINBOX
add action=accept chain=input comment="Allow ICMP #1" limit=50,5:packet \
    log-prefix="" protocol=icmp
add action=accept chain=forward comment="Allow ICMP #2" limit=50,5:packet \
    log-prefix="" protocol=icmp
add action=accept chain=input comment="Allow all  from LAN" in-interface=\
    lan-ABV log-prefix=""
add action=accept chain=forward comment="Allow LAN to Internet" log-prefix=""
add action=drop chain=forward comment="DROP ALL" log=yes log-prefix=""
add action=drop chain=input comment="DROP ALL - Must be LAST rule in table!" \
    log-prefix=""
/ip firewall mangle
add action=mark-connection chain=input in-interface=wan-APG log-prefix="" \
    new-connection-mark=WAN2_conn passthrough=no
add action=mark-connection chain=input in-interface=wan-RTK log-prefix="" \
    new-connection-mark=WAN1_conn passthrough=no
add action=mark-routing chain=output connection-mark=WAN1_conn log-prefix="" \
    new-routing-mark=to_WAN1 passthrough=no
add action=mark-routing chain=output connection-mark=WAN2_conn log-prefix="" \
    new-routing-mark=to_WAN2 passthrough=no
add action=accept chain=prerouting dst-address=91.194.173.0/24 in-interface=\
    lan-ABV log-prefix=""
add action=accept chain=prerouting dst-address=95.156.82.0/24 in-interface=\
    lan-ABV log-prefix=""
add action=mark-routing chain=prerouting connection-mark=WAN1_conn \
    in-interface=lan-ABV log-prefix="" new-routing-mark=to_WAN1 passthrough=\
    no
add action=mark-routing chain=prerouting connection-mark=WAN2_conn \
    in-interface=lan-ABV log-prefix="" new-routing-mark=to_WAN2 passthrough=\
    no
/ip firewall nat
add action=masquerade chain=srcnat comment="Allow LAN to Internet ISP 1" \
    log-prefix="" out-interface=wan-APG
add action=masquerade chain=srcnat comment="Allow LAN to Internet ISP 2" \
    log-prefix="" out-interface=wan-RTK
add action=dst-nat chain=dstnat comment="mobilon in to ats" disabled=yes \
    dst-address=95.156.82.162 dst-port=80 log-prefix="" protocol=tcp \
    src-address=195.130.214.180 to-addresses=10.10.24.20 to-ports=80
add action=dst-nat chain=dstnat comment="sparm to cache RTK" dst-address=\
    95.156.82.162 dst-port=1972 in-interface=wan-RTK log-prefix="" protocol=\
    tcp src-address-list=sparm to-addresses=10.10.24.12 to-ports=1972
add action=dst-nat chain=dstnat comment="sparm to cache RTK backup" \
    dst-address=95.156.82.162 dst-port=1973 in-interface=wan-RTK log-prefix=\
    "" protocol=tcp src-address-list=sparm to-addresses=10.10.24.23 to-ports=\
    1972
add action=dst-nat chain=dstnat comment="sparm to cache RTK" dst-address=\
    95.156.82.162 dst-port=3389 in-interface=wan-RTK log-prefix="" protocol=\
    tcp src-address-list=sparm to-addresses=10.10.24.12 to-ports=3389
add action=dst-nat chain=dstnat comment="lipatov to 1c rdp" dst-port=3389 \
    in-interface=wan-RTK log-prefix="" protocol=tcp src-address-list=lipatov \
    to-addresses=10.10.24.15 to-ports=3389
add action=dst-nat chain=dstnat comment="lipatov to cache" disabled=yes \
    dst-port=1972 in-interface=wan-RTK log-prefix="" protocol=tcp \
    src-address-list=lipatov to-addresses=10.10.24.12 to-ports=1972
add action=dst-nat chain=dstnat comment="any to qms web apg" dst-port=1337 \
    in-interface=wan-APG log-prefix="" protocol=tcp to-addresses=10.10.24.12 \
    to-ports=1337
add action=dst-nat chain=dstnat comment="any to qms web rtk" dst-port=1337 \
    in-interface=wan-RTK log-prefix="" protocol=tcp to-addresses=10.10.24.12 \
    to-ports=1337
add action=dst-nat chain=dstnat comment="sparm to cache APG" dst-address=\
    91.194.173.67 dst-port=1972 in-interface=wan-APG log-prefix="" protocol=\
    tcp src-address-list=sparm to-addresses=10.10.24.12 to-ports=1972
add action=dst-nat chain=dstnat comment="sparm to cache APG" dst-address=\
    91.194.173.67 dst-port=3389 in-interface=wan-APG log-prefix="" protocol=\
    tcp src-address-list=sparm to-addresses=10.10.24.12 to-ports=3389
add action=netmap chain=dstnat dst-address-list="" dst-port=9080 \
    in-interface=all-ethernet log-prefix="" protocol=tcp src-address=\
    195.130.214.180 to-addresses=10.10.24.159 to-ports=80
add action=netmap chain=dstnat disabled=yes dst-address-list="" dst-port=9083 \
    in-interface=all-ethernet log-prefix="" protocol=tcp src-address=\
    195.130.214.180 to-addresses=10.10.24.20 to-ports=80
add action=netmap chain=dstnat dst-address-list="" dst-port=9081 \
    in-interface=all-ethernet log-prefix="" protocol=tcp src-address=\
    195.130.214.180 to-addresses=10.10.24.158 to-ports=80
add action=netmap chain=dstnat dst-address-list="" dst-port=9082 \
    in-interface=all-ethernet log-prefix="" protocol=tcp src-address=\
    195.130.214.180 to-addresses=10.10.24.160 to-ports=80
add action=netmap chain=dstnat comment="olga buhgd from homed" \
    dst-address-list="" dst-port=3389 in-interface=all-ethernet log-prefix="" \
    protocol=tcp src-address=171.33.249.38 to-addresses=10.10.24.72 to-ports=\
    3389
add action=dst-nat chain=dstnat comment="vipnet coordinator" dst-address=\
    95.156.82.162 dst-port=55780 in-interface=wan-RTK log=yes log-prefix="" \
    protocol=udp to-addresses=10.10.24.66 to-ports=55780
/ip firewall service-port
set ftp disabled=yes
set tftp disabled=yes
set irc disabled=yes
set h323 disabled=yes
set pptp disabled=yes
/ip route
add check-gateway=ping comment="ISP 1" distance=1 gateway=95.156.82.161 \
    routing-mark=to_WAN1
add check-gateway=ping comment="ISP 2" distance=2 gateway=91.194.173.65 \
    routing-mark=to_WAN2
add check-gateway=ping comment="ISP 1" distance=1 gateway=95.156.82.161
add check-gateway=ping comment="ISP 2" distance=2 gateway=91.194.173.65
add distance=1 dst-address=192.168.18.0/24 gateway=GRE-brj
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www address=10.10.24.0/24
set api disabled=yes
set api-ssl disabled=yes
/lcd
set backlight-timeout=never default-screen=interfaces read-only-mode=yes \
    touch-screen=disabled
/lcd interface
set sfp1 disabled=yes
set vip-net disabled=yes
set ether4 disabled=yes
set ether5 disabled=yes
set ether6 disabled=yes
set ether7 disabled=yes
set ether8 disabled=yes
set ether9 disabled=yes
/system clock
set time-zone-name=Asia/Krasnoyarsk
/system ntp client
set enabled=yes primary-ntp=91.226.136.136 secondary-ntp=109.195.19.73
/system routerboard settings
set protected-routerboot=disabled
/tool mac-server
set [ find default=yes ] disabled=yes
/tool mac-server mac-winbox
set [ find default=yes ] disabled=yes
add interface=lan-ABV
