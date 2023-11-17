#!/bin/bash
#
#Script feito para derrubar o safado.
#
#Desenvolvido por: DevChimpa 17-11-2023
#
#
##########################################################################


MEU_IP=$( echo $SSH_CLIENT | awk {'print $1'} )

IP_DO_SAFADO=192.168.2.128

if [ $MEU_IP = $IP_DO_SAFADO ]
then

clear

echo "##################################################"
echo "          "
echo "          "
echo "         "
echo "
     /~\
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "#################################################"
sleep 0.5

clear

echo "##################################################"
echo "          ----------------------------------------"
echo "          | Cai fora Maluco!"
echo "         /---------------------------------------"
echo "        /
     /~\
   C(o o)D  -----
    _(^)   /    /
   /__m~\m/____/ "
echo "#################################################"


PTS_ALVO=$( w | grep $IP_DO_SAFADO | awk {' print $2 '} )


PID_DO_ALVO=$( ps aux | grep $PTS_ALVO | awk {'print $2'} )


kill -9 $PID_DO_ALVO


else
        exit 0
        fi
