#!/bin/sh

# ------------------------------------------------------------------------->
# brj@livecd можно создать работая от пользователя ROOT.
# ------------------------------------------------------------------------->

if [ "`id -u`" != "0" ]; then
        echo "Sorry, brj@livecd must be done as root."
	exit 1
fi

# ------------------------------------------------------------------------->
# brj@livecd проверяем на месте ли у нас конфиг
# ------------------------------------------------------------------------->

if [ -f ./config ] ; then
   . ./config
fi

if [ ! -f ${LIVEDIR}/config ]; then
        echo "Sorry, brj@livecd cannot find config file."
	exit 2
fi

# ------------------------------------------------------------------------->
# ШАГ1: Создаем сткуртуру каталогов для дистрибутива brj@livecd
# ------------------------------------------------------------------------->

st1-mtree() {

    # Если $CHROOTDIR существует, значит удаляем все, что в ней есть.

    if [ -r ${CHROOTDIR} ]; then
            chflags -R noschg ${CHROOTDIR}/
    	    rm -rfv ${CHROOTDIR}/
    fi                                   

    # Создаем каталог, в котором содержится chroot brj@livecd

    mkdir -p ${CHROOTDIR}

    # Создаем дерево каталогов в chroot директории brj@livecd

    mtree -deU -f ${LIVEDIR}/files/brjlivecd.dist -p ${CHROOTDIR}
}

# ------------------------------------------------------------------------->
# ШАГ2: Собираем и устанавливаем мир для дистрибутива brj@livecd
# ------------------------------------------------------------------------->

st2-world() {

	cd /usr/src
	make clean
	
	cd /usr/obj
	chflags -R noschg *
	rm -rf /usr/obj

	# Строим мир 
	
	cd /usr/src
	make buildworld

        # Создаем /stand/sysinstall

        cd /usr/src/release/sysinstall/
        make clean
        make

}

st2-worldinst() {

    # Ставим etc мира в наш $CHROOTDIR

    cd /usr/src/etc
    make distrib-dirs DESTDIR=${CHROOTDIR}

    cd /usr/src/etc
    make distribution DESTDIR=${CHROOTDIR}

    # Ставим собранный мир в наш $CHROOTDIR

    cd /usr/src
    make installworld DESTDIR=${CHROOTDIR}

    # Создаем бутстрап в $CHROOTDIR

    #mkdir $CHROOTDIR/bootstrap
    #cp -p $CHROOTDIR/sbin/mount $CHROOTDIR/bootstrap
    #cp -p $CHROOTDIR/sbin/umount $CHROOTDIR/bootstrap

    # Cтавим собранный /stand/sysinstall

    cd /usr/src/release/sysinstall/
    make install

    # Копируем /stand в $CHROOTDIR brj@livecd

    tar -cf - -C /stand . | tar xpf - -C ${CHROOTDIR}/stand/
    
}

# ------------------------------------------------------------------------->
# ШАГ3: Собираем и ставим ядро системы для дистрибутива brj@livecd
# ------------------------------------------------------------------------->

st3-kernel() {

    # Сносим старый каталог с ядром системы и копируем туда ядро

    cp ${LIVEDIR}/files/brjlivecd.kernel ${KERNELDIR}/brjlivecd

    # Строим ядро для brj@livecd

    cd /usr/src
    make buildkernel DESTDIR=${CHROOTDIR} KERNCONF=brjlivecd

}

st3-kernelinst() {

    # Устанавлием посторенное ядро для brj@livecd

    cd /usr/src
    make installkernel DESTDIR=${CHROOTDIR} KERNCONF=brjlivecd
    
}

# ------------------------------------------------------------------------->
# ШАГ5: Устанавливаем выбранные пользователем пакеты
# ------------------------------------------------------------------------->

st5-pkgsel() {

    # Если $PACKAGEDIR существует, значит удаляем все, что в ней есть.

    if [ -r ${PACKAGEDIR} ]; then
            chflags -R noschg ${PACKAGEDIR}/
    	    rm -rfv ${PACKAGEDIR}/
    fi                                   

    # Создаем каталог, в котором содержится пакеты для brj@livecd

    mkdir -p ${PACKAGEDIR}

    # Создаем скрипт, для выбора нужных пакетов к установке

    echo "#!/bin/sh" > ${PKGSEL}
    echo "$DIALOG --title \"brj@livecd - добавление пакетов\" --clear \\" >> ${PKGSEL}
    echo "--checklist \"Это пакеты установленные на вашей машине" >> ${PKGSEL}
    echo "Выберите, те, что вы хотите добавить на brj@livecd\" -1 -1 10 \\" >> ${PKGSEL}

    for i in `ls -1 /var/db/pkg`; do echo "\"$i\" \"\" off \\" >> ${PKGSEL} ; done

    echo "2> ${PKGSELECTED}" >> ${PKGSEL}
    
    # Файл создан. Запускаем его для выбора пакетов.
    
    sh ${PKGSEL}

}

st5-pkg() {

    # Переходим в каталог с пакетами и начинаем их генерацию

    cd ${PACKAGEDIR}
    
    # Удаляем все ранее собранные пакеты
    
    rm -rfv ${PACKAGEDIR}/*.tgz

    # Согласно выбранному делаем генерацию пакетов

    choice=`cat ${PKGSELECTED}`
    for i in `echo $choice | sed -e 's/"/#/g'`; do pkg_create -v -b `echo $i | awk -F"#" '{print $2}'`; done
    
}

st5-pkginst() {

    # Переходим в каталог с пакетами и начинаем их установку

    cd ${PACKAGEDIR}
    
    # Делаем описание пакетов

    mkdir -p ${CHROOTDIR}/brj@livecd/packages
    
    for i in `ls -1 *.tgz`; do /usr/sbin/pkg_info $i > ${CHROOTDIR}/brj@livecd/packages/$i.txt ; done
    
    # Начинаем устанавливать пакеты в $CHROOTDIR

    for i in `ls -1 *.tgz`; do /usr/sbin/pkg_add -vRf -p ${CHROOTDIR}/usr/local $i ; done
    
}

# ------------------------------------------------------------------------->
# DOHACK: Устанавливает хаки на дистрибутив
# ------------------------------------------------------------------------->

selecthack() {

    # Создаем скрипт, для выбора нужных хаков к установке

    echo "#!/bin/sh" > ${HACKSEL}
    echo "$DIALOG --title \"brj@livecd - выбор хаков\" --clear \\" >> ${HACKSEL}
    echo "--checklist \"  Это хаки доступные к установке на дистрибутив" >> ${HACKSEL}
    echo "Выберите, те, что вы хотите добавить на brj@livecd\" -1 -1 10 \\" >> ${HACKSEL}

    # Переходим в HACKDIR

    cd ${HACKDIR}

    for i in `ls -1 *.sh`; do echo "\"$i\" \"\" off \\" >> ${HACKSEL} ; done

    echo "2> ${HACKSELECTED}" >> ${HACKSEL}
    
    # Файл создан. Запускаем его для выбора пакетов.
    
    sh ${HACKSEL}

}

dohack() {

    # Устанавливаем все хаки которые есть в каталоге.

    cd ${HACKDIR}

    # for i in `ls -1 *.sh`; do sh $i ; done
    
    choice=`cat ${HACKSELECTED}`
    for i in `echo $choice | sed -e 's/"/#/g'`; do sh `echo $i | awk -F"#" '{print $2}'`; done


}

# ------------------------------------------------------------------------->
# MAKEISO: Создание образа диска дистрибутива brj@livecd
# ------------------------------------------------------------------------->

makeiso() {

    # Если образ уже существует - удаляем его

    if [ -r ${BRJLIVECDISO} ]; then
            rm ${BRJLIVECDISO}
    fi                                   

    # Создаем архивы для виртуальных файловых систем

    cd $CHROOTDIR

    tar cvzfp mfs/etc.tgz etc
    tar cvzfp mfs/dev.tgz dev
    tar cvzfp mfs/root.tgz root
    tar cvzfp mfs/local_etc.tgz usr/local/etc

    # Копируем загрузчик 

    cp $LIVEDIR/files/boot.catalog $CHROOTDIR/boot

    # Создаем образ диска в ISO

    cd $CHROOTDIR

    ${MKISOFS} \
    -A "${APPLICATION}" -b boot/cdboot -no-emul-boot -c boot/boot.catalog \
    -r -J -h -o ${BRJLIVECDISO} -p "${PREPARER}" -P "${PUBLISHER}" \
    -V "${VOLUME_ID}" .

}

# ------------------------------------------------------------------------->
# BLANKRW: Процедура быстрого стирание RW матрицы
# ------------------------------------------------------------------------->

blankrw() {
    burncd -v -f ${CDRW} -s max blank
}

# ------------------------------------------------------------------------->
# BURNCD: Процедура записи ISO образа на матрицу
# ------------------------------------------------------------------------->

burnbrjlivecd() {

    cat ${BRJLIVECDISO} | burncd -f ${CDRW} -v -e -s max data - fixate

}

# ------------------------------------------------------------------------->
# BRJ@LIVECD: Реальное начало программы
# ------------------------------------------------------------------------->

case "$1" in

    mtree)
	    echo make brj@livecd tree in $CHROOTDIR
	    st1-mtree
	    ;;

    buildworld)
	    echo bilding world
	    st2-world
	    ;;
	    
    installworld)
	    echo installing world to $CHROOTDIR
	    st2-worldinst
	    ;;
	    
    buildkernel)
	    echo bilding brj@livecd kernel
	    st3-kernel
	    ;;
	    
    installkernel)
	    echo installing brj@livecd kernel to $CHROOTDIR
	    st3-kernelinst
	    ;;

    pkgsel)
	    echo bilding and running package selector
	    st5-pkgsel
	    ;;
    pkg)
	    echo bliding selected packages
	    st5-pkg
	    ;;
	    
    pkginst)
	    echo installing selected packages to $CHROOTDIR
	    st5-pkginst
	    ;;

    selecthack)
	    echo selecting hack
	    selecthack
	    ;;

    dohack)
	    echo installing hack
	    dohack
	    ;;

    iso)
	    echo make botable brj@livecd iso file
	    makeiso
	    ;;
	    
    blankrw)
	    echo blanking rw in $CDRW
	    blankrw
	    ;;
	    
    burn)
	    echo burning brj@live cd on $CDRW
	    burnbrjlivecd
	    ;;

	*)
	    echo ""
	    echo "Usage: `basename $0` { see script for param }"
	    echo ""
	    exit 64
	    ;;
	    
esac
