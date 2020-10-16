
```
mkdir /etc/systemd/timesyncd.conf.d
echo -e "[Time]\nNTP=some.ntp.server" > /etc/systemd/timesyncd.conf.d/ntp.conf
timedatectl set-ntp true
```

or

```
timedatectl set-ntp false
echo ptp_kvm > /etc/modules-load.d/ptp_kvm.conf
modprobe ptp_kvm
echo "refclock PHC /dev/ptp0 poll 2" >> /etc/chrony.conf
systemctl restart chronyd
```
