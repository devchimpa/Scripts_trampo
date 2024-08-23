#!/bin/bash
#
# Desenvolvido por: Rodrigo Pinheiro
# Data de Criação: 22/08/2024

# Contato:
# https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
# https://github.com/devchimpa/
#
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################
#
# Este script ira verificar o tempo da ultima mensagem whatsapp em horario
# comercial, caso o tempo esteja muito alto ira registrar o horario ate a proxima
# verificacao. E tomar decisao com base nesses dados
#
#########-VARIAVEIS IMPORTANTES: #########################################


# servidores a serem monitorados:
#SERVIDORES=" 10.20.1.40 "

# define o tempo de espera em segundos
#TEMPO_ESPERA="60"

# Se for sabado o domingo
# a variavel sera utilizada
# para definir o tempo
SABADO="1"
DOMINGO="0"

# horario de trabalho, deve ser colocado: 06_23
# 06 - representa hora inicial
# 23 - representa hora final
HORARIO_COMERCIAL="06_23"


# RESPOSTAS PARA O ZABBIX #
# caso seja necessário verificar tera saida 1 ,2 ou 0 caso
# nao precise verificar.

# OK deve ser igual a 0 para informar que esta tudo certo
OK="0"

# N_OK deve ser igual a 1 para informar alerta amarelo
N_OK="1"

# N_OK_MAXIMO deve ser igual a 2 para informar alerta vermelho
N_OK_MAXIMO="2"

##########################################################################


############- FUNCOES -#######################################################


verifica_conversas(){
# Esta funcao serve para executar o comando no servidor
# e colher o tempo em segundos da ultima mensagem para tomada de acoes.


        RESPOSTA=$( /var/www/cmxom/./psql_exec /var/www/cmxom "select trunc(extract(epoch from now())-timestamp) from messages where channel=15 order by id desc limit 1" 2>/dev/null)

        TEMPO_MENSAGEM=$( echo "$RESPOSTA" | tr -cd 0-9 )

        valida_quantidade

}


valida_quantidade(){
# esta funcao ira contabilizar o tempo da ultima conversa
# caso seja um valor alto, ele imprime o valor
# de verificar ou nao.



        if [ "$TEMPO_MENSAGEM" -ge "$TEMPO_MAXIMO_FORA" ]
then

        echo "$N_OK_MAXIMO"

elif [ "$TEMPO_MENSAGEM" -ge "$TEMPO_MEDIO_FORA" ]

then
        echo "$N_OK"

else
        echo "$OK"
        fi


}


verifica_dia(){
# esta funcao verifica o dia da semana e de
# acordo com o dia um tempo limite e definido

        DIA_ATUAL=$( date +%w )
        if [ "$DIA_ATUAL" -eq "$SABADO" ] || [ "$DIA_ATUAL" -eq "$DOMINGO" ]

        then
# se for fim de semana
# 2 horas fora = amarelo
# 4 horas = vermelho
                TEMPO_MEDIO_FORA="7200"
                TEMPO_MAXIMO_FORA="14400"

                verifica_horario
        else

# se for semana
# 2 horas fora = amarelo
# 4 horas fora = vermelho

                TEMPO_MEDIO_FORA="3600"
                TEMPO_MAXIMO_FORA="7200"

                verifica_horario

                fi
}


verifica_horario(){
#esta funcao verifica o horario comercial
# se estiver no horario, ele segue fluxo
# caso contrario, ele imprime 0

        HORA_ATUAL=$( date +%H )
        HORA_INICIAL=$( echo "$HORARIO_COMERCIAL" | awk -F "_" {'print $1'})
        HORA_FINAL=$( echo "$HORARIO_COMERCIAL" | awk -F "_" {'print $2'} )

        if [ "$HORA_ATUAL" -gt "$HORA_INICIAL" ] && [ "$HORA_ATUAL" -gt "$HORA_FINAL" ]
        then
                echo "$OK"
                exit 0

        else

        verifica_conversas
          fi

}



########### - CHAMADA DE FUNCOES - #############################################
verifica_dia
#verifica_conversas
#verifica_zeradas

