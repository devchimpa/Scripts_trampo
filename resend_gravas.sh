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


passa_diretorios(){
# Esta funcao ira capturar as datas que existem
# transformar em lista e passar para capturar as gravacoes

        DIRETORIOS_VARRER=$( ls $CALLS | grep 2024-06-* )
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
# esta funcao ira definir o destino da gravacao
# se faz parte de receptivas ou ativas

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
# esta funcao valida se o arquivo é avi para
# poder fazer o envio

        if [ "$EXTENSAO" == avi ]
        then
                define_diretorio
        fi
}

copia_gravacao(){
# esta funcao ira realizar as copias para
# o ponto de montagem

        #cria o diretório e faz o envio
#       mkdir -p "$DIRETORIO_DESTINO"

        cp -rpv "$arquivo $DIRETORIO_DESTINO/$UNIQUE_ID.avi"
        echo "$arquivo $DIRETORIO_DESTINO/$UNIQUE_ID.avi"
}


#############################################
passa_diretorios
