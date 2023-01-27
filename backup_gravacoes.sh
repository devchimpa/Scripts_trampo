#!/bin/bash

#       DESCRIÇÃO:
#       LAÇO FOR PARA PEGAR AS GRAVACOES DENTRO DE 3 DIRETÓRIOS CONSECUTIVOS.
#

#############################################################################

CAMINHO_ORIGEM="/home/backups/gravacoes/"
DESTINO_ENVIO="/home/backups/gravacoes/"


##############################################################################
# Criado por: Rodrigo Pinheiro                                               #
# Data: 24/01/2023                                                           #
# Contato:                                                                   #
#           https://www.linkedin.com/in/rodrigo-pinheiro-214663206/          #
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

testa_tempo(){

        if [ "$TEMPORIZADOR" -lt "$NOVENTA_DIAS_ATRAS" ]  || [ "$TEMPORIZADOR" -eq "$NOVENTA_DIAS_ATRAS" ]
        then

                echo "é maior que noventa dias."
                mkdir -p "$CAMINHO_ORIGEM"gravacoes_antigas
                #sleep 2
                cp -rpuv "$arquivo" "$CAMINHO_ORIGEM"gravacoes_antigas

        else


                echo "é menor que noventa dias."
        fi

}


#simulação: gravacoes/desc_ura00/2022-10-20

busca_arquivo(){

        for arquivo in */*/*
  do
        echo $arquivo
        echo "########################################"
        GRAVACAO="$(echo "$arquivo" | cut -d "/" -f "3" )"
        #echo "$GRAVACAO"
        separa_gravacoes "$GRAVACAO"
        echo "$DATA_ORIGINAL"
#       echo "$TEMPORIZADOR"
        #echo "$NOVENTA_DIAS_ATRAS"
        testa_tempo
done

}



busca_arquivo






assinatura(){

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
=e0JI
-----END PGP PUBLIC KEY BLOCK-----
}
