#!/bin/bash

# avcolor=`convert snapshot.jpg -colorspace GRAY -resize 1x1 txt: | sed 's/[^(]*(\s*\([0-9]*\),.*/\1/p;d'`
# echo -n $bright > /proc/acpi/video/VGA/LCD/brightness;

x=320 #ширина фото
y=240 #высота фото
n=1000 # порог проверки фото (от 0 до x*y) - каждый N пиксель будет взят для подсчета
max=40 #максимальный "цвет" (от 0 до 255)
sleep=60 #ожидание, перед повторением операции
maxbright=100 #максимальная яркость
minbright=20 #минимальная яркость
while [ 1 ]; do #бесконечный цикл
    ffmpeg -f video4linux2 -s ${x}x${y} -i /dev/video0 -f image2 /tmp/snapshot.jpg 2>/dev/null #делаем скрин
    convert /tmp/snapshot.jpg -colorspace gray /tmp/snapshot.jpg #обесцвечиваем его
    sum=0
    count=0
    let "s = x*y" #всего пикселей
        color=(`convert /tmp/snapshot.jpg[${x}x${y}+0+0] -depth 8 txt: | tail -n +2 | sed -n 's/^.*\(#[^ ]*\).*$/\1/p' | cut -c2-3`); #массив цветов пикселей, у которых взял только R из RGB, грубо говоря. Цвет то серый
        for i in `seq 0 $n $s`; #для каждого N-го
       						 do			
                #переводим цвет из 16-ричной в десятичную запись
                color1=`echo ${color[i]} | cut -c1-1` 
                color2=`echo ${color[i]} | cut -c2-2`
                case "$color1" in
                    "A"  ) color1=10;;					
                    "B"  ) color1=11;;
                    "C"  ) color1=12;;
                    "D"  ) color1=13;;
                    "E"  ) color1=14;;
                    "F"  ) color1=15;;
                esac
                case "$color2" in
                    "A"  ) color2=10;;					
                    "B"  ) color2=11;;
                    "C"  ) color2=12;;
                    "D"  ) color2=13;;
                    "E"  ) color2=14;;
                    "F"  ) color2=15;;
                esac
                let "rgbcolor = color1*16+color2"
                let "sum = sum+rgbcolor" #сумма "цветов". Потом поделим на количество и получим средний цвет
                let "count = count+1" #считаем количество
                
        done
        	
    let "avcolor = sum/count" #средний цвет
    #echo "Цвет: $avcolor" #раскомментировать для просмотра яркости при максимальном освещении (чтобы вписать в max)
    let "bright=avcolor*100/$max" #яркость
        #проверка на максимальную и минимальную яркость
        if [ $bright -gt $maxbright ]; then 
        bright=$maxbright 
    fi
    if [ $bright -lt $minbright ]; then 
        bright=$minbright 
    fi
    xbacklight -set $bright #устанавливаем яркость экрана
    echo "Установлена яркость: $bright"
    sleep $sleep #спим
done

