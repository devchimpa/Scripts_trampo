#!/bin/bash
##############################################################################
#       DESCRIÇÃO:
#       LAÇO FOR PARA PEGAR AS GRAVACOES DENTRO DE 3 DIRETÓRIOS CONSECUTIVOS.
#       E COMPARAR SE TEM MAIS OU MENOS QUE 90 DIAS.

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
NOVENTA_DIAS_ATRAS="$( date -d "-90 days" +%s )"


separa_gravacoes (){
        GRAVACAO_RECEBIDA=$1
        UNIQUEID="$(echo "$GRAVACAO_RECEBIDA" | cut -d "." -f 1)"
        TEMPORIZADOR="$( echo "$UNIQUEID" | cut -c 3-12)"
        ORIGEM_URA="$( echo "$UNIQUEID" | cut -c 1-2)"
        DATA_ORIGINAL="$( date +%Y-%m-%d -d @"$TEMPORIZADOR" )"
}

#simulação: gravacoes/desc_ura00/2022-10-20

busca_arquivo(){

        for disc in */*/*
  do
        echo $disc
        echo "########################################"
        GRAVACAO="$(echo "$disc" | cut -d "/" -f "3" )"
        echo "$GRAVACAO"
        separa_gravacoes "$GRAVACAO"
        echo "$DATA_ORIGINAL"
#       echo "$TEMPORIZADOR"
        #echo "$NOVENTA_DIAS_ATRAS"
        if [ "$TEMPORIZADOR" -lt "$NOVENTA_DIAS_ATRAS" ] || [ "$TEMPORIZADOR" -eq "$NOVENTA_DIAS_ATRAS" ]
        then

                echo "é maior que noventa dias."
        else


                echo "é menor que noventa dias."
        fi

done

}




busca_arquivo
