#!/bin/bash
#
# Desenvolvido por: DevChimpa
# Data de Criação: 12/09/2024

# Contato:
# https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
# https://github.com/devchimpa/
#
#######################################################################
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################
#
# Script criado com o objetivo de enviar as gravações avi
# para os pontos de montagem 10.20.0.86
#
########################################################################

# VARIAVEIS DE CONFIGURAÇÃO

# ponto de montagem para onde as gravacoes devem
# ser enviadas:
MONTAGEM="/home/extend/gravacoes/"

# locais de busca onde as gravacoes
# devem estar:
CALLS="/home/gravacoes/gra_home0/"
#CALLS="/home/gravacoes/brb_call/"

#######################################################
# /home/gravacoes/gra_home0/2024-06-01/596281_1717267562054_081717267512.2879.avi
# 120176_1717274343617_091717274178.3549.avi

passa_diretorios(){

        DIRETORIOS_VARRER=$( ls $CALLS | grep 2024-06-* )
#       echo "$DIRETORIOS_VARRER"
        for diretorio in ${DIRETORIOS_VARRER[*]}
                do
                        cata_gravacao $diretorio
                done

}



cata_gravacao(){

# esta é a funcao principal do script, ela captura as gravacoes no diretorio
# e filtra os campos para tomadas de açoes das copia ativas e recepetivas

PASSA_DATA=$1

for arquivo in /home/gravacoes/gra_home0/"$PASSA_DATA"/*

        do

        UNIQUE_ID=$( echo $arquivo | tr "/" " " | awk {'print $5'} | tr "_" " " | awk {'print $3'} | tr -d "." | tr -d aA-zZ )

        ATIVO_RECEPTIVO=$( echo "$UNIQUE_ID" | cut -c 1-2 )

        EXTENSAO=$( echo $arquivo | tr "/" " " | awk {'print $5'} | tr "_" " " | awk {'print $3'} | tr -d "." | tr -d 0-9 )

        TIMESTAMP_GRAVACAO=$( echo $UNIQUE_ID | cut -c 3-12 )

        DIRETORIO_DATA=$( date -d @"$TIMESTAMP_GRAVACAO" +%Y-%m-%d )

        valida_extensao

        done

}

define_diretorio(){


 if [ "$ATIVO_RECEPTIVO" -eq 99 ]
                then

                        echo " gravacao ativa: $UNIQUE_ID.avi"

                        DIRETORIO_DESTINO="$MONTAGEM"ativo/"$DIRETORIO_DATA"
                        copia_gravacao
                else
                        echo "gravacao receptiva: $UNIQUE_ID.avi"
                        DIRETORIO_DESTINO="$MONTAGEM"receptivo/"$DIRETORIO_DATA"
                        copia_gravacao
       fi


}


valida_extensao(){

        if [ "$EXTENSAO" == avi ]
        then
                define_diretorio
        fi
}

copia_gravacao(){

        #cria o diretório e faz o envio

        echo "$arquivo $UNIQUE_ID.avi"
}


#############################################
passa_diretorios
#cata_gravacao
