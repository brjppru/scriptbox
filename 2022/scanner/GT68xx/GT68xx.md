# GT68xx scanner run

here is the blob from 

- http://www.meier-geinitz.de/sane/gt68xx-backend/
- http://www.meier-geinitz.de/sane/gt68xx-backend/adding.html

Mustek	BearPaw 1200 CU Plus	CIS	6816 	0x055f	0x021b 	PS1Gfw.usb	Works.

`
root@pve:~# scanimage -L
device `gt68xx:libusb:001:005' is a Mustek Bearpaw 1200 CU Plus flatbed scanner
`

# debug run

Mustek	BearPaw 1200 CU Plus	CIS	6816 	0x055f	0x021b 	PS1Gfw.usb	Works.

`
brjed@T15:~$ scanimage -T
[17:06:04.770966] [gt68xx] Couldn't open firmware file (`/usr/share/sane/gt68xx/PS1Gfw.usb'): No such file or directory

scanimage: open of device gt68xx:libusb:001:021 failed: Invalid argument
`
