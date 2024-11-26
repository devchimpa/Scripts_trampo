#!/bin/bash
#
# Desenvolvido por: DevChimpa
# Data de Criação: 26/11/2024

# Contato:
# https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
# https://github.com/devchimpa/
#
#######################################################################
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################
#
#       O objetivo desse script é fazer a captura de latência
#       dos entroncamentos.
#       Este script e passivel de melhoria, caso tenha melhoras a
#       acrescentar, inserir modificacoes abaixo.
#
########################################################################
#
##############-Siga o modelo abaixo caso mexa no script:-###############
#
# Modificado por:
# Data:
# Contato:
# Modificação feita:
#
##########################################################################
LOG_DE_LATENCIA="/home/log_latencia"

DATA_DO_LOG=$(  date +%H:%M_%d'/'%m'/'%Y )


echo >> "$LOG_DE_LATENCIA"

echo "$DATA_DO_LOG" >> "$LOG_DE_LATENCIA"

echo "|" >> "$LOG_DE_LATENCIA"

# comando para fazer a captura
CAPTURA=$( /usr/sbin/comunix -rx "sip show peers" | grep -v UNKNOW | grep -v Name | grep -v Monitored | tr -s " " | tr " " "_" )

# Neste trecho ele faz a separacao
# de cada linha para poder escrever no log
for item in ${CAPTURA[*]}
do
        echo $item >> "$LOG_DE_LATENCIA"

done

echo >> "$LOG_DE_LATENCIA"

