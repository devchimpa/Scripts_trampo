#!/bin/bash
#
#Desenvolvido por: DevChimpa
#Data inicial: 26/05/2023

#Contato:
#https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
#https://github.com/devchimpa/
#
#######################################################################
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################
resume_programa(){

        clear
        echo "

        O programa está dividido em várias funções e cada uma cuida de um trecho para
facilitar a manutenção, leitura e entendimento sobre seu funcionamento.
        Cada Função é bem descritiva sobre a sua responsabilidade e o
        programa está separado em dois trechos:

        - o primeiro,  onde as funções e variáveis são declaradas
        - o segundo onde ocorre a inicialização do programa.
        Permitindo assim que apenas determinadas funções sejam testadas.

        O objetivo deste programa é acelerar algumas atividades diárias
        que possuem certa simplicidade em sua identificação e resolução.

        como por exemplo a primeira opção, que acelera os testes de read-only, disco
        inode, identificação de arquitetura e virtualização.

        "
}
########################################################################
#
############## Siga o modelo abaixo caso mexa no script: ###############
#
#Modificado por:
#Data:
#Contato:
#Modificação feita:
#
##########################################################################


#IP_PENTAHO=$(for linha in $(cat global.php) ; do echo $linha | grep pentaho | grep host | cut -d '=' -f 3 | tr -d [aA-zZ] | tr -d ';' | tr -d ' ' ; done )


###########################################################################
                                #FUNÇÕES#
###########################################################################



desenha_macaco(){
echo "############################################################"
echo "           ------------------------------------------------"
echo "           $1                                             "
echo "         /-------------------------------------------------"
echo "        /
     /~\
   C(o o)D   -----
    _(^)   /    /
   /__m~\m/____/ "
echo "############################################################"
}

desenha_macaco2(){
echo "############################################################"
echo "           -----------------------------------------------"
echo "          $1                                             "
echo "         /------------------------------------------------"
echo "        /
     /~\
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "###########################################################"
}


verifica_geral(){

clear

echo "###########################################################"
DIA=$(date +%Y-%m-%d)
HORA=$(date +%H:%M)

echo "Verifique se a data e hora está correta: $DIA $HORA"


echo "###########################################################"

echo "###########################################################"
echo "          Verifique os discos.                    "
echo "###########################################################"
df -h | grep -v /dev/loop
echo "###########################################################"
echo "          Verifique os Inodes.                    "
echo "###########################################################"
df -ih | grep -v /dev/loop

echo "###########################################################"
echo "          Verifque se está read-only.             "

touch /home/$DIA-testefeito
ls /home/$DIA-testefeito

echo "###########################################################"
echo " A arquitetura do sistema é: "
arch
echo "###########################################################"
MAQUINA_VIRTUAL=$(lspci | grep -i vm | wc -l)
#echo $MAQUINA_VIRTUAL

if [ "$MAQUINA_VIRTUAL" -eq 0 ]
then
        echo "          Esta é uma máquina física"
else
        echo "          Esta é uma máquina virtual."
fi

echo "###########################################################"
echo "Este é um debian: "
cat /etc/debian_version
echo "###########################################################"

desenha_macaco "Estas são as verificações básicas..."


echo "###########################################################"

}

envia_arquivo(){

SERVIDORES=$1

# Localização do arquivo
ARQUIVO=/home/chimpa/Documents/Caderno/Shellscript/mata_report.sh

DESTINO=/home/xenobot


# Envio via SCP
for i in ${SERVIDORES}
        do
                echo "Enviando arquivo ${ARQUIVO} para o servidor ${i}"
                sshpass  -p 'kira2971'  scp -rp ${ARQUIVO} ${i}:${DESTINO}
                sleep 1
#                sshpass -p '/ext!00x' ssh ${i} "${COMANDO}"

        done

}




mata_report(){
        clear
        desenha_macaco2 " Matando o report. "

COMANDO=/home/xenobot/mata_report.sh
#       COMANDO="ps aux | grep bash | awk -F ' ' '{print $1}' | xargs -i kill -9 {}"

#COMANDO="ps aux | grep pentaho | awk -F " " '{print $2}' | xargs -n1 -i kill -9 {}"

for i in ${IP_PENTAHO}
        do
                clear
                desenha_macaco "Enviando comando..."
                echo "---> Servidor ${i}--->$COMANDO"
                #sshpass -p '/ext!00x' ssh ${i} "${COMANDO}"
                sshpass -p 'kira2971' ssh ${i} "${COMANDO}"


        done

}



ENVIA_COMANDO(){


SERVIDORES="
        192.168.1.2
"


COMANDO="touch /home/testechimpa"

for i in ${SERVIDORES}
        do
                desenha_macaco "Enviando comando..."
                echo "---> Servidor ${i}--->$COMANDO"
                sshpass -p '/ext!00x' ssh ${i} "${COMANDO}"


        done

}








chama_programa(){

        case "$ESCOLHA_FUNCAO" in
        1)
                verifica_geral
                ;;
        2)
                manager_travado
                ;;

        5)
                procura_report

                ;;
        r|R)
                clear
                resume_programa
                ;;
        *)
                echo " Esta função ainda não está disponível"
                ;;
esac
}

manager_travado(){

        PID_TRATA_PROC=$(ps aux | grep /trata_proc | grep -v "grep" | awk {'printf $2'} | tr -d [a-z])

        clear
        desenha_macaco2 "Matei o Pid: $PID_TRATA_PROC do trata_proc
                e reiniciei o restartd"
        # /etc/init.d/restartd restart

}






procura_report(){
        clear
        desenha_macaco2 "Um momento enquanto procuro o IP..."
IP_PENTAHO=$(for linha in $(cat global.php) ; do echo $linha | grep pentaho | grep host | cut -d '=' -f 3 | tr -d [aA-zZ] | tr -d ';' | tr -d ' ' ; done )
        sleep 1
        confere_ip


}





confere_ip(){


        clear
desenha_macaco "Confere o IP do report? $IP_PENTAHO "
echo "        Pressione 'Y' para sim ou 'N' para Não."
echo "###########################################################"

        read IP_CORRETO
        case "$IP_CORRETO" in

                y | Y)
                        clear
                        testa_ip $IP_PENTAHO
                        envia_arquivo $IP_PENTAHO
                        sleep 2
                        mata_report
                #       ENVIA_COMANDO
                        ;;

                n|N)
                        clear
                        desenha_macaco2 "Por favor, informe o IP correto..."
                        read IP_PENTAHO
                        confere_ip
                        ;;


                *)
                        clear
                        desenha_macaco  " Opção inválida. "
                        encerra_programa
                        ;;
               esac


}


testa_ip(){

        desenha_macaco2 "Testando conexão $1..."
SEM_CONTATO=$(ping -c 1 "$1" | grep loss | tr -d [aA-zZ] | cut -d ',' -f 3 | tr -d '%')

        if [ "$SEM_CONTATO" -eq 100 ]

        then
                clear
                desenha_macaco "Este IP está fora de alcance..."
                sleep 2
                confere_ip
        fi
}





encerra_programa(){

        clear
        desenha_macaco " Encerrando programa..."
        sleep 2
        clear
        exit

}



################################################################################
                        #PROGRAMA
################################################################################


echo "###########################################################"

clear
desenha_macaco2 " Escolha uma das opções e pressione ENTER..."


echo "###########################################################"
echo "
        (1)-Verificação_Básica
        (2)-Manager_travado
        (3)-Operador_não_atende
        (4)-Não_Loga_no_Webphone
        (5)-Restaurar_Report
        (6)-Fila_zerada
        (R)-Resumo_do_Programa
        "
echo""
echo "###########################################################"

###############################################################################
        #Lê a escolha do usuário.
###############################################################################

read ESCOLHA_FUNCAO
chama_programa


#PID_TRATA_ESTATISTICA=$(ps aux | grep ./trata_estatistica | grep -v "grep" | awk {'printf $2'} | tr -d [a-z])
#PID_TRATA_PROC=$(ps aux | grep ./trata_proc | grep -v "grep" | awk {'printf $2' } | tr -d [a-z])
#PID_TRATA_TR_AGENTE=$(ps aux | grep ./trata_tr_agente_servico | grep -v "grep" | awk {'printf $2' } | tr -d [a-z])
#ps aux | grep pentaho | awk -F " " '{print $2}' | xargs -n1 -i kill -9 {}
#IP_PENTAHO=$(for linha in $(cat global.php) ; do echo $linha | grep pentaho | grep host | cut -d '=' -f 3 | tr -d [aA-zZ] | tr -d ';' | tr -d ' ' ; done )
#cat /var/www/comunix/config/autoload/global.php
