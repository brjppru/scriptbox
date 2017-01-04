#!/bin/sh

exit 0

brjdaily="/backup/daily"

# ----------------------------------------------------
# grab skype
# ----------------------------------------------------

    skype="$brjdaily/SkypeSetupFull-(`date +%Y-%m-%d-%H%M%S`).exe"
    axel -o ${skype} http://www.skype.com/go/getskype-full

    skypemsi="$brjdaily/SkypeSetupMSI-(`date +%Y-%m-%d-%H%M%S`).msi"
    axel -o ${skypemsi} http://www.skype.com/go/getskype-msi

# ----------------------------------------------------
# grab tv + ammy
# ----------------------------------------------------

    tv="$brjdaily/tv-(`date +%Y-%m-%d-%H%M%S`).exe"
    axel -o $tv http://download.teamviewer.com/download/TeamViewer_Setup_ru.exe

    aa="$brjdaily/aa-(`date +%Y-%m-%d-%H%M%S`).exe"
    axel -o $aa http://www.ammyy.com/AA_v3.exe

    mango="$brjdaily/mango-cov-(`date +%Y-%m-%d-%H%M%S`).exe"
    axel -o $mango http://www.mango-office.ru/upload/Mango-Call-Center.exe

# ----------------------------------------------------
# grab 2gis it's to buggy mirror!
# ----------------------------------------------------

    msigis="$brjdaily/2gis-(`date +%Y-%m-%d-%H%M%S`).msi"
    axel -o ${msigis} "http://disk.2gis.com/2gis.msi"

    again=1
    gis="$brjdaily/2gis-krsk-(`date +%Y-%m-%d-%H%M%S`).exe"

    while [ $again -ne 0 ]; do

	rm $gis
	axel -n20 -o ${gis} "http://info.2gis.ru/distributive/cumulative/krasnoyarsk/"

	getit=`file -b $gis`

	if [ "$getit" = "PE32 executable (GUI) Intel 80386, for MS Windows" ]
	    then again=0
	    else again=1
	fi

	echo $again - $getit

    done

# ----------------------------------------------------
# clear old + rsync to dropbox
# ----------------------------------------------------

find  $brjdaily -type f -ctime +2 -print | xargs rm
rsync -avhrh --del --progress $brjdaily /root/Dropbox/dupe2015/online

