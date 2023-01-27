#!/bin/bash
#
############################################################################
#                                                                          #
#       DESCRIÇÃO:                                                         #
#                                                                          #
#       O OBJETIVO DO SCRIPT É PERCORRER AS PASTAS A PARTIR DO DIRETÓRIO:  #
#       /home/gravacoes DO STORAGE       BUSCAR AS GRAVAÇÕES               #
#       COM UM TEMPO SUPERIOR OU IGUAL A 90 DIAS E SALVAR EM UM BACKUP     #
#       PARA DESOCUPAR O ESPAÇO EM DISCO.                                  #
#                                                                          #
#                                                                          #
#                                                                          #
############################################################################

#para funcionar o caminho deve ser terminado em '/'
CAMINHO_ORIGEM="/home/backups/gravacoes/"
DESTINO_ENVIO="/home/backups/gravacoes/"


##############################################################################
# Criado por: Rodrigo Pinheiro                                               #
# Comunix Tecnologia                                                         #
# Data: 24/01/2023                                                           #
# Contato:                                                                   #
#         https://www.linkedin.com/in/rodrigo-pinheiro-214663206/            #
#         https://github.com/devchimpa/                                      #
#                                                                            #
##############################################################################


# CAMINHO EXEMPLO
# Disc_00 -> Ura00 ->  2022-01-01  -> WAV

# ir para o caminho inicial

cd "$CAMINHO_ORIGEM"

NOVENTA_DIAS_ATRAS="$( date -d "-90 days" +%s )"

separa_gravacoes (){

        #separa campos das gravacoes

        GRAVACAO_RECEBIDA=$1
        UNIQUEID="$(echo "$GRAVACAO_RECEBIDA" | cut -d "." -f 1)"
        TEMPORIZADOR="$( echo "$UNIQUEID" | cut -c 3-12)"
        ORIGEM_URA="$( echo "$UNIQUEID" | cut -c 1-2)"
        DATA_ORIGINAL="$( date +%Y-%m-%d -d @"$TEMPORIZADOR" )"
}

testa_tempo(){

        # testa se o id da gravação é menor ou igual 90 dias

        if [ "$TEMPORIZADOR" -lt "$NOVENTA_DIAS_ATRAS" ]  || [ "$TEMPORIZADOR" -eq "$NOVENTA_DIAS_ATRAS" ]
        then

                echo "é maior que noventa dias."
                mkdir -p "$DESTINO_ENVIO"gravacoes_antigas
                #sleep 2
                cp -rpuv "$arquivo" "$DESTINO_ENVIO"gravacoes_antigas

        else
                echo "é menor que noventa dias."
        fi

}


busca_arquivo(){

        #varre os diretórios em busca das gravações e guarda na variável $arquivo

        for arquivo in */*/*
  do
        echo $arquivo
        echo "########################################"
        GRAVACAO="$(echo "$arquivo" | cut -d "/" -f "3" )"

        #echo "$GRAVACAO"
        separa_gravacoes "$GRAVACAO"

        echo "$DATA_ORIGINAL"
        echo "$TEMPORIZADOR"

        #echo "$NOVENTA_DIAS_ATRAS"

        # chama a função testa tempo para poder validar o timestamp
        testa_tempo

done

}

################################ Chaves de funções ##################################

busca_arquivo
