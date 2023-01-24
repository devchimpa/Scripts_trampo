#!/bin/bash

#       DESCRIÇÃO:
#       LAÇO FOR PARA PEGAR AS GRAVACOES DENTRO DE 3 DIRETÓRIOS CONSECUTIVOS.
#

#############################################################################

CAMINHO_ORIGEM="/home/backups/gravacoes/"
DESTINO_ENVIO="/home/backups/gravacoes/"


##############################################################################
# criado por: DevChimpa                                                      #
# Data: 24/01/2023                                                           #
# Contato: chimpadeveloper@gmail.com                                         #
#         https://github.com/devchimpa/                                      #
#                                                                            #
##############################################################################
#
# Caminho = Disc -> Ura ->  Datas -> Gravacoes
#

cd "$CAMINHO_ORIGEM"
DATA_ATUAL="$( date +%Y-%m-%d )"

separa_gravacoes (){
        GRAVACAO_RECEBIDA=$1
        UNIQUEID="$(echo "$GRAVACAO_RECEBIDA" | cut -d "." -f 1)"
        TEMPORIZADOR="$( echo "$UNIQUEID" | cut -c 3-12)"
        ORIGEM_URA="$( echo "$UNIQUEID" | cut -c 1-2)"
        DATA_ORIGINAL="$( date +%Y-%m-%d -d @"$TEMPORIZADOR" )"
}

#simulação: gravacoes/desc_ura00/2022-10-20

busca_arquivo(){

        for disc in *
  do
        echo $disc
        echo "##################"
        cd $disc
        for ura in *
        do
                echo $ura
                cd $ura
                for i in *
                do
                        CAMINHO_ARQUIVO="$( pwd )"
                        GRAVACAO=$(echo $i )
                        echo "$CAMINHO_ARQUIVO""/$GRAVACAO"
                        separa_gravacoes $GRAVACAO
                        sleep 1

                done
        cd ..
        done
        cd ..
done
}
busca_arquivo
