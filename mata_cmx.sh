#!/bin/bash

#Desenvolvido por: Rodrigo Pinheiro
#Data: 05/03/2024

#Contato:
#https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
#https://github.com/devchimpa/
#
#########################################################################
#
#       OBJETIVO:
#       Este script deve fazer um stop gracefully no comunix a 00h
#       dos sábados e quando não houver mais chamadas em curso
#       o serviço deve ser encerrado e inicializado novamente.
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
TEMPO_DE_ESPERA=60

# data para registros de logs
DATA_DE_INICIO=$(  date +%d-%m-%y_%H:%M )

# Verificador de chamadas em andamento.
#CHAMADAS_ATIVAS=$( comunix -rx "core show calls" | grep "active" | awk {'print $1'} 2>>/dev/null  )

echo $CHAMADAS_ATIVAS

LOG_DE_ERRO="/home/extend/erro-$0"

##########################################################################
#                         FUNCOES DO SCRIPT:                             #
##########################################################################



valida_chamadas(){
# Esta função guarda quantas chamadas estão em andamento.

        if [ -z "$CHAMADAS_ATIVAS" ]
        then
        CHAMADAS_ATIVAS=0
        else
        CHAMADAS_ATIVAS=$( comunix -rx "core show calls" | grep "active" | awk {'print $1'} 2>>/dev/null )
        fi
}


stop_gracefully(){
#Esta função irá iniciar a parada do Comunix

        echo "Stop Grecefully!"
        comunix -rx "core stop gracefully"
        # Este trecho irá verificar se as chamadas ainda estão em andamento.
        # Este valor deve ser zero.

        while [ "$CHAMADAS_ATIVAS" -ne 0 ]

        do
                # aguarda um período para encerrar o Comunix.
                sleep "$TEMPO_DE_ESPERA"
                echo "Aguardando encerramento..."

        # chama função para determinar se as chamadas zeraram.
                valida_chamadas
done

}




encerra_comunix(){

    #esta função irá encerrar o Comunix caso a quantidade de chamadas em curso seja igual a zero
    if [ "$CHAMADAS_ATIVAS" -eq 0 ]
then

        pkill comunix
    echo "Matou Comunix"
        sleep 3
    #PROCESSOS_COMUNIX=$( pgrep comunix )

else
         echo " Erro inesperado: $DATA_DE_INICIO $CHAMADAS_ATIVAS " >> "chamadas em curso: $LOG_DE_ERRO"

fi
}




inicia_comunix(){

        /etc/init.d/comunix.sh start
        echo "Iniciando o Comunix"

}



##########################################################################
#                        CHAMADA DE FUNÇÕES                              #
##########################################################################

valida_chamadas

stop_gracefully

encerra_comunix

inicia_comunix

#########################################################################
