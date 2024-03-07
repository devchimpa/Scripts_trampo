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
#       23 59 * * 6 /home/extend/scripts/stop-fully.sh
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
# é o tempo esperado entre a execução de cada função
TEMPO_DE_ESPERA=1

# Esta é uma variável de controle, ela irá determinar as ações do script e não deve ser alterada.
CHAMADAS_ATIVAS=$( /usr/sbin/comunix -rx "core show calls" | grep "active" | awk {'print $1'} 2>>/dev/null )

# data para registros de logs
DATA_DE_INICIO=$(  date +%d-%m-%y_%H:%M )

LOG_DE_ERRO="/home/extend/erro-stop-fully"



##########################################################################
#                         FUNCOES DO SCRIPT:                             #
##########################################################################


valida_chamadas(){
# Esta função guarda quantas chamadas estão em andamento
# e altera para zero caso o valor seja vazio.
# o valor sendo zero, o Comunix será reiniciado por outras funções.

        CHAMADAS_ATIVAS=$( /usr/sbin/comunix -rx "core show calls" | grep "active" | awk {'print $1'} 2>>/dev/null )

        if [ -z "$CHAMADAS_ATIVAS" ]
        then

        VALIDADOR=0

        else
        # caso a variável não esteja vazia, será declarado o número de chamadas
        # o esperado é que seja zero para que o Comunix seja reiniciado.

        VALIDADOR="$CHAMADAS_ATIVAS"

        fi
}


stop_gracefully(){
#Esta função irá iniciar a parada do Comunix
#se o valor de VALIDADOR for zero ele inicia a parada.



        while [ "$VALIDADOR" -ne 0 ]

        do
                sleep "$TEMPO_DE_ESPERA"

                # chama a função para determinar se as chamadas zeraram.
                valida_chamadas
done
        # VALIDADOR sendo zero, a parada inicia.
        /usr/sbin/comunix -rx "core stop gracefully"
        DESLIGOU=$( echo $? )


}


reinicia_comunix(){

        #esta função irá encerrar o Comunix caso o processo do gracefully
        #tenha sido encerrado corretamente.
    if [ "$DESLIGOU" -eq 0 ]
then

        pkill comunix
        sleep "$TEMPO_DE_ESPERA"

        /etc/init.d/comunix.sh start
        sleep "$TEMPO_DE_ESPERA"
        /usr/sbin/comunix -rx "core show uptime"
else
        pkill comunix
        /etc/init.d/comunix.sh start
        sleep "$TEMPO_DE_ESPERA"
        /usr/sbin/comunix -rx "core show uptime"
        DATA_FINAL=$(  date +%d-%m-%y_%H:%M )
        echo "Hora inicial: $DATA_DE_INICIO Data final: $DATA_FINAL" >> $LOG_DE_ERRO
        echo "Erro $DESLIGOU  no stop gracefully. " >> $LOG_DE_ERRO
        fi

}



##########################################################################
#                        CHAMADA DE FUNÇÕES                              #
##########################################################################

valida_chamadas

stop_gracefully

reinicia_comunix

#########################################################################
