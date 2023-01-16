#!/bin/bash
# Script para envio de arquivos para vários servidores.
#############
#
#
########################## CRIADOR DESCONHECIDO ################################
#
# Todos servidores
SERVIDORES="
    172.172.172.172
    172.172.172.172
    172.172.172.172
    172.172.172.172
    172.172.172.172
    172.172.172.172
    172.172.172.172
    172.172.172.172
    172.172.172.172
"

# Localização do arquivo
ARQUIVO=/home/extend/scripts/filtrando-bilhetes.sh
DESTINO=/home/extend/scripts/filtrando-bilhetes.sh

#ARQUIVO2=/var/lib/asterisk/agi-bin/trata_saudacao.agi
#DESTINO2=/var/lib/asterisk/agi-bin/trata_saudacao.agi


# Envio via SCP
for i in ${SERVIDORES}
        do
                echo "Enviando arquivo ${ARQUIVO} para o servidor ${i}"
                sshpass -p '#senha' scp -rp ${ARQUIVO} ${i}:${DESTINO}

                #echo "Enviando arquivo ${ARQUIVO2} para o servidor ${i}"
                #sshpass -p '#senha' scp -rp ${ARQUIVO2} ${i}:${DESTINO2}

               #sshpass -p #senha' ssh ${i} "asterisk -rx 'dialplan reload'"
                #sleep 1

        done
