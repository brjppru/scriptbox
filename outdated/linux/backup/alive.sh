= ru.unix.bsd (2:5090/73) =====================================================
 Msg  : 1 of 12                             
 From : Lev Walkin                          2:5020/400      Thu 22 Jul 04 09:45
 To   : Ivan Poplavsky
 Subj : Re: Hужна программулина
===============================================================================
From: Lev Walkin <vlm@netli.com>


Ivan Poplavsky wrote:

> Hello, Lev!
> You wrote to Ivan Poplavsky on Wed, 21 Jul 2004 13:06:23 +0000 (UTC):
> 
> 
>  LW> Ivan Poplavsky wrote:
>  ??>> Hello, All!
>  ??>>
>  ??>> Есть сервер на котором крутится Tomcat-4.0.6. Томкэт периодически
>  ??>> помирает из-за нехватки памяти, но при этом всё равно висит на своём
>  ??>> порту и принимает соединения. Hужна какая-нить прогрммулина которая
>  ??>> отслеживала бы это дело, и посылала почту либо сама перезагружала
>  ??>> сервак.
> 
>  LW> while :; do
>  LW>  curl http://hostname/ || reboot
>  LW>  sleep 5;
>  LW> done
> 
> Спасибо, но там не один хост. Там куча виртуальных серверов. Бывает, что
> один или два хоста умерли, а остальные пашут.

вот ведь проблему изобрел на ровном месте...


while :; do
        alive=0
        curl http://hostname1/ && alive=$((alive+1))
        curl http://hostname2/ && alive=$((alive+1))
        curl http://hostname3/ && alive=$((alive+1))
        [ $alive = 0 ] && reboot
        sleep 5;
done


-- 
Lev Walkin
vlm@netli.com

--- ifmail v.2.15dev5.3
 * Origin: Netli, Inc. (2:5020/400)

