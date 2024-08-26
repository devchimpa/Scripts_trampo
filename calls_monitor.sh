#!/bin/bash
#
##############################################################################
# Criado por: Rodrigo Pinheiro                                               #
# Comunix Tecnologia                                                         #
# Data: 01/08/2024                                                           #
# Contato:                                                                   #
#         https://www.linkedin.com/in/rodrigo-pinheiro-214663206/            #
#         https://github.com/devchimpa/                                      #
#                                                                            #
##############################################################################
#
############################################################################
#                                                                          #
#       DESCRIÇÃO:                                                         #
#                                                                          #
#       O objetivo do programa é acompanhar a quantidade de bilhetes       #
#       no diretorio /home/extend/calls/main                               #
#       e caso haja um volume alto, reiniciar o processo...                #
#       !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!         #
#       Este script necessita do pacote sudo para executar a função        #
#               de reiniciar o trata                                               #
#                                                                          #
############################################################################

# VARIÁVEIS DE CONFIGURAÇÃO
# Diretório base onde as pastas dos dias estão localizadas
DIRETORIO="/home/extend/calls/main"

# ESTA VARIAVEL CAPTURA O ANO ATUAL
# PARA CONTABILIZAR OS BILHETES DO ANO
ANO=$( date +%Y )

# AQUI DEVE SER INSERIDO O VALOR CONSIDERADO ALTO
# PARA A QUANTIDADE DE BILHETES NO SERVIDOR
LIMITE=50

# ESTA VARIAVEL É A SOMA DOS BILHETES
# E DEVE SER CONFIGURADA COM O VALOR 0
# ELA SERA COMPARADA COM A VARIAVEL LIMTE.
SOMA="0"

########################################################################

#VALORES INTERPRETADOS PELO ZABBIX

ERROR="1"

OK="0"

######################## FUNÇÕES #######################################

mata_e_sobe_trata(){

PID_DO_TRATA=$( ps aux | grep  /home/extend/./trata_send_bilhete_tcp | grep -v grep | awk {'print $2'} )

# este trecho precisa de sudo para ser executado pelo usuario zabbix
        sudo kill -9 $PID_DO_TRATA

        sudo /home/extend/./trata_send_bilhete_tcp &

}

# FUNÇÃO PARA VERIFICAR OS BILHETES

contagem_bilhetes() {
# esta funçao faz a contabilidade
# de bilhetes por dia

for diretorio_dia in "$DIRETORIO"/"$ANO"-*/
do
        if [ -d "$diretorio_dia" ]
         then
                CONTAGEM=$(ls "$diretorio_dia" | wc -l)
                                SOMA=$( expr "$CONTAGEM" + "$SOMA" )
    fi
  done
}

valida_limite(){

        if [ "$SOMA" -gt "$LIMITE" ]
        then
                echo "$ERROR"
                # caso não tenha o pacote sudo, deixar
                # a funcao abaixo comentada
                #mata_e_sobe_trata
        else
                echo "$OK"
        fi

}

##############################################################################################
                               #CHAMADA DE FUNÇÕES#
##############################################################################################
contagem_bilhetes
valida_limite
