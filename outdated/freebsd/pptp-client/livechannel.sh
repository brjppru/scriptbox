#!/bin/sh

#
# живой канал? 
#
# Скрипт проверяет на живучесть три хоста аплинков, если те не живые то
# дропает насмерть pptp, мож он завис? гыгыгы... тупой скрипт, но рабочий.
#
#

VPNIP=172.16.0.1
COREIP=80.255.136.38
TIP=10.10.10.1

  /sbin/ping -n -c1 -q ${VPNIP} > /dev/null 2>&1
  if [ $? -ne  0 ]
    then

    /sbin/ping -n -c10 -q ${VPNIP} > /dev/null 2>&1
      if [ $? -ne  0 ]
          then

	        logger -t livechannel "VPN IP destanation unreachable"

		/sbin/ping -n -c10 -q ${COREIP} > /dev/null 2>&1
		
	          if [ $? -ne  0 ]
	          then

		    logger -t livechannel "REAL IP gateway destanation unreachable"

			# Ага. Реальный не пингуется совсем. 
			# Пробуем попинговать 10тку, если ее тоже нету
			# ничего не делаем

				/sbin/ping -n -c10 -q ${TIP} > /dev/null 2>&1
		
			          if [ $? -ne  0 ]
			          then
				  
				  # Нет Пинга? Выходим. Значит и связи нет.
				  
				  logger -t livechannel "Transport IP destanation unreachable, exit."

				  exit
				  
				  fi
				  
			# А если мы дошли сюда, значит связь есть с корой
			# Дропаем pptp

			killall -9 pptp
			logger -t livechannel "transport IP gateway reachable, restarting pptp"

		  fi
      fi
fi
