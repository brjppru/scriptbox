#!/bin/sh

labelhdd=/tmp/label.brjhdd

prepare() {

# ������� ���� �� ������� ����� ������� brj@livecd
/bin/dd if=/dev/zero of=/dev/$disco count=128
sleep 5

# �������� ���������� � �����
/sbin/fdisk -I $disco
sleep 5

# �������������� ����
/sbin/disklabel -rw ${disco}s1 auto
sleep 5

# ������� �������� �� �����
/sbin/disklabel -r ${disco}s1 > $labelhdd

# ���������� ������� ������ ��� ����� �� �����
setores_disco=`/sbin/disklabel -r ${disco}s1 | /usr/bin/tr -s ' ' | \
          /usr/bin/sed 's/^ //g' | /usr/bin/grep '^c: ' | \
          /usr/bin/cut -f2 -d' '`

# ���������� ������� ������ ������ �� ����
b_raiz=`expr $raiz \* 1024 \* 2`
b_swap=`expr $swap \* 1024 \* 2`
b_var=`expr $var \* 1024 \* 2`
b_usr=`expr $setores_disco \- $b_raiz \- $b_swap \- $b_var`

# ���������� �������� /var � /usr
off_var=`expr $b_raiz \+ $b_swap`
off_usr=`expr $b_raiz \+ $b_swap \+ $b_var`

# ������� ������ �����, ��� �� ����� ������ ��� disklabel
echo "a: $b_raiz 0 4.2BSD 0 0 0" >>  $labelhdd
echo "b: $b_swap $b_raiz swap" >>  $labelhdd 
echo "e: $b_var $off_var 4.2BSD 0 0 0"  >>  $labelhdd  
echo "g: $b_usr $off_usr 4.2BSD 0 0 0"  >>  $labelhdd 

# ������� �������� �� ����� "bootavel"
/sbin/disklabel -R -B ${disco}s1 $labelhdd
sleep 5

# ������� �������� ��������
/sbin/newfs /dev/${disco}s1a
sleep 5

# ������� �������� var
/sbin/newfs /dev/${disco}s1e
sleep 5

# ������� �������� usr
/sbin/newfs /dev/${disco}s1g

# ���������, ���������� �� ����������. ���� �� ��� �������.
if [ ! -c /dev/${disco} ]; then
  (cd /dev && MAKEDEV ${disco})
fi

if [ ! -c /dev/${disco}s1 ]; then
  (cd /dev && MAKEDEV ${disco}s1)
fi

if [ ! -c /dev/${disco}s1a ]; then
  (cd /dev && MAKEDEV ${disco}s1a)
fi

if [ ! -c /dev/${disco}s1b ]; then
  (cd /dev && MAKEDEV ${disco}s1b)
fi

if [ ! -c /dev/${disco}s1e ]; then
  (cd /dev && MAKEDEV ${disco}s1e)
fi

if [ ! -c /dev/${disco}s1g ]; then
  (cd /dev && MAKEDEV ${disco}s1g)
fi

# ��������� �����
/sbin/mount /dev/${disco}s1a /mnt
sleep 5
mkdir /mnt/usr

/sbin/mount /dev/${disco}s1g /mnt/usr
sleep 5
mkdir /mnt/var

/sbin/mount /dev/${disco}s1e /mnt/var
sleep 5

# ���������� ����-����
swapon /dev/${disco}s1b

# �������� ������ ����� �� ���������
cd /mnt
for i in bin boot bootstrap dev etc home modules root sbin stand tmp var
do
  cp -Rvp /$i .
  sleep 5
done

cp /.cshrc /mnt
sleep 2
cp /.profile /mnt
sleep 2
cp /COPYRIGHT /mnt
sleep 2
cp /dist/fstab.install /mnt/etc/fstab
sleep 2
cp /dist/rc /mnt/etc/rc
sleep 2

cd /mnt/usr
for i in bin games include lib libdata libexec local obj sbin share src
do
  cp -Rvp /usr/$i .
  sleep 5
done

# ������� ���������� �� ����������
cd /mnt/dev
./MAKEDEV all

# �������� ���� �� ���������
cp /dist/kernel /mnt/kernel

# ������ ������
mtree -deU -f /dist/LiveCD.mtree -p /mnt > /dev/null &&

# ���������� �������� � ������� ����� �����������
echo rootdev="${disco}s1a" >> /mnt/boot/loader.conf

cd /

sleep 30

# ������������ ��� �������
/sbin/umount /mnt/usr
/sbin/umount /mnt/var
/sbin/umount /mnt

}

# Atencao!!!!
# 
# A execucao em modo batch NAO pede confirmacao, use com cuidado!!!
#
# Para usar em modo batch batch , basta executar o comando com 4 parametros:
# instalar_frebsd.sh disco raiz swap var, por ex: 
# instalar_freebsd.sh ad0 200 256 2000, instala o freebsd criando 
# - / com 200MB
# - swap com 2256MB
# - /var com 2GB
# - /usr com o restante do disco
# Se executar com menos de 4 parametros entra em modo interativo.

if [ "$#" -lt 4 ] ; then
   idioma
   disco 
   aviso
elif then
   disco=$1
   raiz=$2
   swap=$3
   var=$4 
   prepare
fi
