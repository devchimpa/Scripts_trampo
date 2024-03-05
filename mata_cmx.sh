#!/bin/bash

#Desenvolvido por: Rodrigo Pinheiro
#Data: 05/03/2024

#Contato:
#https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
#https://github.com/devchimpa/
#
#########################################################################
#                                                                       #
#       OBJETIVO:                                                       #
#       Este script deve fazer um stop gracefully no comunix a 00h      #
#       dos sábados e quando não houver mais chamadas em curso          #
#       o serviço deve ser encerrado e inicializado novamente.          #
#                                                                       #
#                                                                       #
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

# tempo de espera para aguardar as chamadas encerrarem.
TEMPO_DE_ESPERA=10

DATA_DE_INICIO=$(  date +%d-%m-%y_%H:%M )

# Verificador de chamadas em andamento.

CHAMADAS_ATIVAS=$( comunix -rx "core show calls" | grep "active" | awk {'print $1'} )

LOG_DE_ERRO="/home/extend/erro-$0"

##########################################################################
#                         FUNCOES DO SCRIPT:                             #
##########################################################################


verifica_andamento(){

        # Esta função irá verificar se as chamadas ainda estão em andamento.
        # Este valor deve ser zero.
        while [ "$CHAMADAS_ATIVAS" -ne 1 ]

        do
                # aguarda um período para encerrar o Comunix.
                sleep "$TEMPO_DE_ESPERA"

                CHAMADAS_ATIVAS=$( comunix -rx "core show calls" | grep "active" | awk {'print $1'} )

                # variavel de teste
                CHAMADAS_ATIVAS=1

done
}


encerra_comunix(){

    #esta função irá encerrar o Comunix caso a quantidade de chamadas em curso seja igual a zero
    if [ "$CHAMADAS_ATIVAS" -eq 0 ]
then

    echo "Matou Comunix"
        sleep 3
    PROCESSOS_COMUNIX=$( pgrep comunix )

else
         echo " Erro inesperado: $DATA_DE_INICIO $CHAMADAS_ATIVAS " >> "chamadas em curso: $LOG_DE_ERRO"

fi
}

inicia_comunix(){

        echo "iniciando o Comunix"

}


verifica_andamento

encerra_comunix

inicia_comunix
