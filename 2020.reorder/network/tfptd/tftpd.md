Нужно подготовить список команд посредством которых я смогу развернуть TFTP сервис на Ubuntu Trusty, будь это Desktop или Server редакция. Порой просто необходим сервис для обновления оборудования, бекапа firmware и вот он.


ekzorchik@srv-trusty:~$ sudo apt-get install -y tftpd-hpa

ekzorchik@srv-trusty:~$ sudo mkdir /tftpboot

ekzorchik@srv-trusty:~$ sudo chmod -R 777 /tftpboot/

ekzorchik@srv-trusty:~$ sudo chown -R nobody:nogroup /tftpboot/

ekzorchik@srv-trusty:~$ sudo cp /etc/default/tftpd-hpa /etc/default/tftpd-hpa.backup

ekzorchik@srv-trusty:~$ sudo vi /etc/default/tftpd-hpa

# /etc/default/tftpd-hpa
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/tftpboot"
TFTP_ADDRESS=":69"
TFTP_OPTIONS="--secure --create --verbose"

ekzorchik@srv-trusty:~$ sudo service tftpd-hpa restart

tftpd-hpa stop/waiting
tftpd-hpa start/running, process 2271

ekzorchik@srv-trusty:~$ sudo netstat -tulpn | grep tftp

udp 0 0 0.0.0.0:69 0.0.0.0:* 2271/in.tftpd 
udp6 0 0 :::69 :::* 2271/in.tftpd

Итак сервис tftpd поднят на Ubuntu Trusty Server, ничего не изменилось по сравнению когда я поднимал его на Ubuntu Precise

