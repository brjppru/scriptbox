
Configura tu Raspberry como servidor de impresión en tres pasos

En casa, tenemos una única impresora, que compartimos a base de intercambiar el cable USB entre un ordenador y otro. Sin embargo, con la llegada de la Raspberry Pi a casa, una de las tareas que tenía pendientes era la de montar un servidor de impresión. De esta forma, utilizando la Raspberry como servidor de impresión tenemos el problema solucionado, puesto que podemos imprimir desde cualquier dispositivo.

Además, no solo tenemos disponible la impresora física, sino que además dispondremos de una impresora PDF. Con lo que si en casa tenemos algún equipo con Windows, no necesitaremos instalar ningún software adicional para imprimir a PDF, sino que podremos utilizar directamente el servidor.

En cuanto a la impresora física que tenemos, se trata de una Aculaser M1200 de Epson que para instalarla me ha dado algún que otro quebradero de cabeza, y que solucioné en su días con los artículos “Impresora AcuLaser M1200 en Ubuntu” e “Instalando la impresora y el escáner otra vez”. Si tu también tienes problemas al instalar esta impresora, te recomiendo que leas ambos artículos, empezando por el segundo.

A continuación encontrarás el procedimiento para utilizar tu Raspberry como servidor de impresión. Igual que en artículos anteriores, está el procedimiento detallado por una parte, y por otra parte, he creado un script en GitHub que te permitirá realizar la instalación de forma mas sencilla. Al igual que comenté en otros artículos de esta serie, te recomiendo que le des un vistazo al procedimiento detallado, porque es una manera muy interesante de aprender Linux, aunque luego utilices el script para la instalación.

Configura tu Raspberry como servidor de impresión en tres pasos. Portada.

La Raspberry como servidor de impresión

Como ya he comentado en otros artículos, dado el bajo consumo de la Raspberry Pi, podemos tenerla siempre en funcionamiento. Esto es ideal para tener en marcha diferentes servicios que nos hagan la vida mas sencilla. Uno de estos servicios es el de utilizar la Raspberry como servidor de impresión.

¿En que consiste esto de utilizar la Raspberry como servidor de impresión? Esto es algo tan sencillo como conectar nuestra impresora o impresoras directamente a la Raspberry Pi. De esta forma será la Raspberry Pi la que se encargue de gestionar nuestras impresiones. No solo las que se puedan hacer directamente en la Raspberry Pi, sino las que se envían desde cualquier dispositivo de nuestra red a la impresora.
Configurando la Raspberry como servidor de impresión
Lo primero actualizar

Por defecto, y como viene siendo habitual, lo primero sería actualizar el firmware de nuestra Raspberry Pi. Siempre y cuando no lo hayamos hecho recientemente. Para actualizarlo, ejecutaremos la siguiente orden en un emulador de terminal,

sudo rpi-update

Dependiendo del resultado de la actualización, es posible, que sea necesario reiniciar la pequeña máquina, para ello, ejecutaremos la orden,

sudo reboot

Una vez actualizado el firmaware, pasamos a actualizar los paquetes. Para actualizar los paquetes ejecutaremos las órdenes,

sudo apt update -y
sudo apt upgrade -y

Instalando

Una vez actualizado el firmware y actualizados los paquetes, pasamos a realizar la instalación, que es algo tan sencillo como ejecuta el siguiente comando en un emulador de terminal,

sudo apt install -y cups cups-pdf printer-driver-gutenprint

En mi caso particular, no me dejaba instalarlo porque tenía un paquete previamente instalado que me impedía hacerlo. En particular se trataba de libcups2. Estuve buscando la solución, para continuar con la instalación a pesar de este paquete. Sin embargo, la solución era mucho mas sencilla de lo que me podía imaginar. Simplemente tuve que desinstalar libcups2 y volver a ejecutar la ordena anterior.
Configurando…

Lo pirmero que vamos a hacer es añadir a nuestro usuario, en mi caso pi al grupo lpadmin. Para ello, ejecutaremos la siguiente orden,

sudo usermod -aG lpadmin pi

A continuación vamos a modificar algunas líneas del archivo /etc/cups/cupsd.conf. En particular haremos lo siguiente,

    Sustituir Listen localhost:631 por Port 631
    Añadir Allow @local en los apartados <Location />, <Location /admin> y <Location /admin/conf>
    Añadir al final del archivo dos líneas ServerName raspberrypi y BrowseAddress 192.168.1.255

Todo esto se puede hacer ejecutando las siguientes órdenes,

sudo sed -i “s|Listen localhost:631|Port 631|g” /etc/cups/cupsd.conf
sudo sed -i “s||Allow all\n|g” /etc/cups/cupsd.conf
Compartiendo impresoras y otras opciones

El siguiente paso para tener nuestra Raspberry como servidor de impresión, es habilitar la posibilidad de compartir impresoras y permitir la administración remota. Para ello, ejecutaremos las siguientes órdenes,

sudo cupsctl --share-printers --remote-admin
sudo sed -i "s|Shared No|Shared Yes|g" /etc/cups/printers.conf

Para compartir la impresora PDF, ejecutaremos la siquiente orden,

sudo lpoptions -d PDF -o printer-is-shared=true

Por último si queremos que cuando se produzca algún error al imprimir un documento o archivo, se intente imprimir de nuevo, ejecutaremos la siguiente orden,

sudo sed -i -e "s|BrowseAddress|ErrorPolicy retry-job\nJobRetryInterval 30\nBrowseAddress|g" /etc/cups/cupsd.conf

Reiniciar, parar o iniciar nuestro servidor de impresión

Una vez realizadas todas estas acciones, lo único que nos queda es reiniciar nuestro servidor de impresión para que tenga en cuenta todas estas opciones. Para reiniciar el servidor de impresión la orden a ejecutar es,

sudo /etc/init.d/cups restart

También hay que tener en cuenta dos ordenes mas que nos permitirán detener el servidor de impresión e iniciar el servidor de impresión. En resumen, todas las acciones sobre el servidor de impresión serán las siguientes,

    Iniciar -> sudo /etc/init.d/cups start
    Parar -> sudo /etc/init.d/cups stop
    Reiniciar -> sudo /etc/init.d/cups restart

¿Donde van los PDF al imprimir?

Un pequeño detalle, pero importante, es conocer el destino de nuestros PDF cuando utilizamos la impresora PDF de la Raspberry para imprimir. Los archivos una vez imprimidos los encontraras en tu Raspberry en var/spool/cups-pdf/ANONYMOUS/.

Puedes cambiar el directorio de salida editando el archivo /etc/cups/cups-pdf.conf con derechos de administrador, evidentemente. Buscas la línea #AnonDirName=/var/spool/cups-pdf/ANONYMOUS y la sustituyes por AnonDirName=/srv/PDF(por ejemplo).

sudo sed -i "s|#AnonDirName=/var/spool/cups-pdf/ANONYMOUS|AnonDirName=/srv/PDF|g" etc/cups/cups-pdf.conf

Evidentemente tienes que tener creado el directorio y con los permisos adecuados. Respecto al tema de los permisos, mi recomendación es que le des permisos de 755 al directorio y propiedad al usuario nobodydel grupo nogroup. Resumiendo,

sudo mkdir -p /srv/PDF
sudo chown nobody:nogroup /srv/PDF
sudo chmod 755 /srv/PDF

Como administrar tu servidor

La administración de tu servidor es muy sencilla. Tan solo tienes que abrir un Firefox o Chrome, o cualquier otro navegador de internet, y dirigirte a la dirección IP de tu Raspberry. En mi caso http://192.168.1.48:631/admin. Allí encontrarás una página como la siguiente, donde puedes gestionar de forma muy sencilla tus impresoras.

Configura tu Raspberry como servidor de impresión en tres pasos. Gestión.
Utilizando un script

Por último, y tal y como he comentado en la introducción, he implementado un sencillo script que nos permite condensar estos pasos en tres órdenes muy sencillas, de forma que una vez ejecutados tendrás configurada tu Raspberry como servidor de impresión.

wget https://raw.githubusercontent.com/atareao/raspberry-scritps/master/install_print_server.sh
chmod +x install_print_server.sh
sudo ./install_print_server.sh

Conclusiones

Como ves tener tu Raspberry como servidor de impresión es algo muy sencillo, pero sobre todo muy interesante y útil. Con muy poco trabajo puedes tener tu impresora o todas tus impresoras compartidas para utilizarlas por todos los usuarios de la red, sin tener que preocuparte de nada.

Más información,

    Machine Cycle
    TechRadar
    GeekyTheory
    Penguin Tutor
    Ubuntu

La entrada Configura tu Raspberry como servidor de impresión en tres pasos aparece primero en El atareao.

URL: https://www.atareao.es/ubuntu/raspberry-como-servidor-de-impresion/
