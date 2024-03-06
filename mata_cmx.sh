#!/bin/bash

#Desenvolvido por: Rodrigo Pinheiro
#Data: 05/03/2024

#Contato:
#https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
#https://github.com/devchimpa/
#
#########################################################################
#
#
#       DESCRIÇÃO:
#       Este script deve fazer um stop gracefully no comunix a 00h
#       dos sábados e quando não houver mais chamadas em curso
#       o serviço deve ser encerrado e inicializado novamente.
#
#       !! IMPORTANTE !!
#
#       O script deve ser configurado no crontab da seguinte maneira:
#
#       0 0 * * 6 /home/extend/scripts/stop-fully.sh
#
#       E o script deverá estar em:
#
#       /home/extend/scripts/stop-fully.sh
#
#
############## Siga o modelo abaixo caso mexa no script: ################
#
#
#Modificado por:
#Data:
#Contato:
#Modificação feita:
#
#
##########################################################################
#                       VARIAVEIS DE CONFIGURAÇÃO:                       #
##########################################################################



# tempo de espera em SEGUNDOS para aguardar as chamadas encerrarem.
TEMPO_DE_ESPERA=3

# Esta é uma variável de controle, ela que determina as ações do script e não deve ser alterada.
CHAMADAS_ATIVAS=$( comunix -rx "core show calls" | grep "active" | awk {'print $1'} 2>>/dev/null )

# data para registros de logs
DATA_DE_INICIO=$(  date +%d-%m-%y_%H:%M )

LOG_DE_ERRO="/home/extend/erro-$0"



##########################################################################
#                         FUNCOES DO SCRIPT:                             #
##########################################################################



valida_chamadas(){
# Esta função guarda quantas chamadas estão em andamento
# e altera para zero caso o valor seja vazio.
# o valor sendo zero, o Comunix será reiniciado por outras funções.

        CHAMADAS_ATIVAS=$( comunix -rx "core show calls" | grep "active" | awk {'print $1'} 2>>/dev/null )

        if [ -z "$CHAMADAS_ATIVAS" ]
        then
        VALIDADOR=0
        else
        VALIDADOR=1
        fi
}


stop_gracefully(){
#Esta função irá iniciar a parada do Comunix

        echo "Stop Gracefully!"
        comunix -rx "core stop gracefully" &


        while [ "$VALIDADOR" -ne 0 ]

        do
                # aguarda um período para encerrar o Comunix.
                sleep "$TEMPO_DE_ESPERA"
                #echo "Aguardando encerramento..."

                # chama a função para determinar se as chamadas zeraram.
                valida_chamadas
done

}




encerra_comunix(){

    #esta função irá encerrar o Comunix caso a quantidade de chamadas em curso seja igual a zero
    if [ "$VALIDADOR" -eq 0 ]
then

        pkill comunix
        #echo "Matou Comunix"
        sleep 3
    #PROCESSOS_COMUNIX=$( pgrep comunix )

else
         echo " Erro inesperado: $DATA_DE_INICIO $CHAMADAS_ATIVAS " >> "chamadas em curso: $LOG_DE_ERRO"

fi
}




inicia_comunix(){

        /etc/init.d/comunix.sh start
        #echo "Iniciando o Comunix"
        sleep 2 
        comunix -rx "core show uptime"

}



##########################################################################
#                        CHAMADA DE FUNÇÕES                              #
##########################################################################

valida_chamadas

stop_gracefully

encerra_comunix

inicia_comunix

#########################################################################
