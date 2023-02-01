#!/bin/sh

# ------------------------------------------------------------------------->
# brj@livecd ����� ������� ������� �� ������������ ROOT.
# ------------------------------------------------------------------------->

if [ "`id -u`" != "0" ]; then
        echo "Sorry, brj@livecd must be done as root."
	exit 1
fi

# ------------------------------------------------------------------------->
# brj@livecd ��������� �� ����� �� � ��� ������
# ------------------------------------------------------------------------->

if [ -f ./config ] ; then
   . ./config
fi

if [ ! -f ${LIVEDIR}/config ]; then
        echo "Sorry, brj@livecd cannot find config file."
	exit 2
fi

# ------------------------------------------------------------------------->
# ���1: ������� ��������� ��������� ��� ������������ brj@livecd
# ------------------------------------------------------------------------->

st1-mtree() {

    # ���� $CHROOTDIR ����������, ������ ������� ���, ��� � ��� ����.

    if [ -r ${CHROOTDIR} ]; then
            chflags -R noschg ${CHROOTDIR}/
    	    rm -rfv ${CHROOTDIR}/
    fi                                   

    # ������� �������, � ������� ���������� chroot brj@livecd

    mkdir -p ${CHROOTDIR}

    # ������� ������ ��������� � chroot ���������� brj@livecd

    mtree -deU -f ${LIVEDIR}/files/brjlivecd.dist -p ${CHROOTDIR}
}

# ------------------------------------------------------------------------->
# ���2: �������� � ������������� ��� ��� ������������ brj@livecd
# ------------------------------------------------------------------------->

st2-world() {

	cd /usr/src
	make clean
	
	cd /usr/obj
	chflags -R noschg *
	rm -rf /usr/obj

	# ������ ��� 
	
	cd /usr/src
	make buildworld

        # ������� /stand/sysinstall

        cd /usr/src/release/sysinstall/
        make clean
        make

}

st2-worldinst() {

    # ������ etc ���� � ��� $CHROOTDIR

    cd /usr/src/etc
    make distrib-dirs DESTDIR=${CHROOTDIR}

    cd /usr/src/etc
    make distribution DESTDIR=${CHROOTDIR}

    # ������ ��������� ��� � ��� $CHROOTDIR

    cd /usr/src
    make installworld DESTDIR=${CHROOTDIR}

    # ������� �������� � $CHROOTDIR

    #mkdir $CHROOTDIR/bootstrap
    #cp -p $CHROOTDIR/sbin/mount $CHROOTDIR/bootstrap
    #cp -p $CHROOTDIR/sbin/umount $CHROOTDIR/bootstrap

    # C����� ��������� /stand/sysinstall

    cd /usr/src/release/sysinstall/
    make install

    # �������� /stand � $CHROOTDIR brj@livecd

    tar -cf - -C /stand . | tar xpf - -C ${CHROOTDIR}/stand/
    
}

# ------------------------------------------------------------------------->
# ���3: �������� � ������ ���� ������� ��� ������������ brj@livecd
# ------------------------------------------------------------------------->

st3-kernel() {

    # ������ ������ ������� � ����� ������� � �������� ���� ����

    cp ${LIVEDIR}/files/brjlivecd.kernel ${KERNELDIR}/brjlivecd

    # ������ ���� ��� brj@livecd

    cd /usr/src
    make buildkernel DESTDIR=${CHROOTDIR} KERNCONF=brjlivecd

}

st3-kernelinst() {

    # ����������� ����������� ���� ��� brj@livecd

    cd /usr/src
    make installkernel DESTDIR=${CHROOTDIR} KERNCONF=brjlivecd
    
}

# ------------------------------------------------------------------------->
# ���5: ������������� ��������� ������������� ������
# ------------------------------------------------------------------------->

st5-pkgsel() {

    # ���� $PACKAGEDIR ����������, ������ ������� ���, ��� � ��� ����.

    if [ -r ${PACKAGEDIR} ]; then
            chflags -R noschg ${PACKAGEDIR}/
    	    rm -rfv ${PACKAGEDIR}/
    fi                                   

    # ������� �������, � ������� ���������� ������ ��� brj@livecd

    mkdir -p ${PACKAGEDIR}

    # ������� ������, ��� ������ ������ ������� � ���������

    echo "#!/bin/sh" > ${PKGSEL}
    echo "$DIALOG --title \"brj@livecd - ���������� �������\" --clear \\" >> ${PKGSEL}
    echo "--checklist \"��� ������ ������������� �� ����� ������" >> ${PKGSEL}
    echo "��������, ��, ��� �� ������ �������� �� brj@livecd\" -1 -1 10 \\" >> ${PKGSEL}

    for i in `ls -1 /var/db/pkg`; do echo "\"$i\" \"\" off \\" >> ${PKGSEL} ; done

    echo "2> ${PKGSELECTED}" >> ${PKGSEL}
    
    # ���� ������. ��������� ��� ��� ������ �������.
    
    sh ${PKGSEL}

}

st5-pkg() {

    # ��������� � ������� � �������� � �������� �� ���������

    cd ${PACKAGEDIR}
    
    # ������� ��� ����� ��������� ������
    
    rm -rfv ${PACKAGEDIR}/*.tgz

    # �������� ���������� ������ ��������� �������

    choice=`cat ${PKGSELECTED}`
    for i in `echo $choice | sed -e 's/"/#/g'`; do pkg_create -v -b `echo $i | awk -F"#" '{print $2}'`; done
    
}

st5-pkginst() {

    # ��������� � ������� � �������� � �������� �� ���������

    cd ${PACKAGEDIR}
    
    # ������ �������� �������

    mkdir -p ${CHROOTDIR}/brj@livecd/packages
    
    for i in `ls -1 *.tgz`; do /usr/sbin/pkg_info $i > ${CHROOTDIR}/brj@livecd/packages/$i.txt ; done
    
    # �������� ������������� ������ � $CHROOTDIR

    for i in `ls -1 *.tgz`; do /usr/sbin/pkg_add -vRf -p ${CHROOTDIR}/usr/local $i ; done
    
}

# ------------------------------------------------------------------------->
# DOHACK: ������������� ���� �� �����������
# ------------------------------------------------------------------------->

selecthack() {

    # ������� ������, ��� ������ ������ ����� � ���������

    echo "#!/bin/sh" > ${HACKSEL}
    echo "$DIALOG --title \"brj@livecd - ����� �����\" --clear \\" >> ${HACKSEL}
    echo "--checklist \"  ��� ���� ��������� � ��������� �� �����������" >> ${HACKSEL}
    echo "��������, ��, ��� �� ������ �������� �� brj@livecd\" -1 -1 10 \\" >> ${HACKSEL}

    # ��������� � HACKDIR

    cd ${HACKDIR}

    for i in `ls -1 *.sh`; do echo "\"$i\" \"\" off \\" >> ${HACKSEL} ; done

    echo "2> ${HACKSELECTED}" >> ${HACKSEL}
    
    # ���� ������. ��������� ��� ��� ������ �������.
    
    sh ${HACKSEL}

}

dohack() {

    # ������������� ��� ���� ������� ���� � ��������.

    cd ${HACKDIR}

    # for i in `ls -1 *.sh`; do sh $i ; done
    
    choice=`cat ${HACKSELECTED}`
    for i in `echo $choice | sed -e 's/"/#/g'`; do sh `echo $i | awk -F"#" '{print $2}'`; done


}

# ------------------------------------------------------------------------->
# MAKEISO: �������� ������ ����� ������������ brj@livecd
# ------------------------------------------------------------------------->

makeiso() {

    # ���� ����� ��� ���������� - ������� ���

    if [ -r ${BRJLIVECDISO} ]; then
            rm ${BRJLIVECDISO}
    fi                                   

    # ������� ������ ��� ����������� �������� ������

    cd $CHROOTDIR

    tar cvzfp mfs/etc.tgz etc
    tar cvzfp mfs/dev.tgz dev
    tar cvzfp mfs/root.tgz root
    tar cvzfp mfs/local_etc.tgz usr/local/etc

    # �������� ��������� 

    cp $LIVEDIR/files/boot.catalog $CHROOTDIR/boot

    # ������� ����� ����� � ISO

    cd $CHROOTDIR

    ${MKISOFS} \
    -A "${APPLICATION}" -b boot/cdboot -no-emul-boot -c boot/boot.catalog \
    -r -J -h -o ${BRJLIVECDISO} -p "${PREPARER}" -P "${PUBLISHER}" \
    -V "${VOLUME_ID}" .

}

# ------------------------------------------------------------------------->
# BLANKRW: ��������� �������� �������� RW �������
# ------------------------------------------------------------------------->

blankrw() {
    burncd -v -f ${CDRW} -s max blank
}

# ------------------------------------------------------------------------->
# BURNCD: ��������� ������ ISO ������ �� �������
# ------------------------------------------------------------------------->

burnbrjlivecd() {

    cat ${BRJLIVECDISO} | burncd -f ${CDRW} -v -e -s max data - fixate

}

# ------------------------------------------------------------------------->
# BRJ@LIVECD: �������� ������ ���������
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
