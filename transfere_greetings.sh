#!/bin/bash
#
##############################################################################
# Criado por: Rodrigo Pinheiro                                               #
# Comunix Tecnologia                                                         #
# Data: 08/04/2024                                                           #
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
#       O objetivo do programa é organizar os arquivos greetings do web    #
#       Localizados em /var/files/greetings                                #
#       O script usa como base o documento de texto localizado em:         #
#       /home/extend/scripts/greetings_list para fazer a leitura           #
#       de origem e destino                                                #
#                                                                          #
#                                                                          #
############################################################################

LISTA="/home/extend/scripts/greetings_list"
REGISTROS_DE_ATIVIDADE="/home/extend/scripts/REGISTROS_DE_ATIVIDADE"

valida_caminho(){

        #essa função irá varrer a lista e chamar
        #a função que valida a existência dos diretórios.
for LINHA in $(cat $LISTA)

do
#       printf "\r $LINHA"
        CONTA_ORIGEM=$(echo $LINHA | awk -F "-" {'print $1'})
        CONTA_DESTINO=$(echo $LINHA | awk -F "-" {'print $2'})
sleep 0.1

        CAMINHO_ORIGEM="/var/files/greetings/$CONTA_ORIGEM"
        CAMINHO_DESTINO="/var/files/greetings/$CONTA_DESTINO"

        #Esta função irá verificar se a origem existe:
        verifica_origem

        done
}


verifica_origem(){

        # Esta função irá verificar se existe origem para fazer cópia
        # caso não exista o diretório ou arquivo serão criados logs explicativos em: /home/extend/scripts/$REGISTROS_DE_ATIVIDADE

if [ ! -d $CAMINHO_ORIGEM ]

then

        echo "$CONTA_ORIGEM não existe diretório. $CONTA_DESTINO deverá ser gravado." >> $REGISTROS_DE_ATIVIDADE

        # caso o caminho de origem exista, ele irá verificar se existe arquivos para serem copiados
elif
        [ $(ls "$CAMINHO_ORIGEM" | wc -l ) -eq 0 ]
# se o retorno for zero, então não há arquivos.
then

echo "$CONTA_ORIGEM não tem gravação. $CONTA_DESTINO deverá ser gravado." >> $REGISTROS_DE_ATIVIDADE

else
        # se existir diretório e arquivos, ele verifica se existe destino
        # para enviar os arquivos.
        verifica_destino

fi

}


verifica_destino(){

if [ ! -d $CAMINHO_DESTINO ]

then
        #Caso o caminho de destino não existir ele é criado
        #e então as gravações são copiadas

        mkdir -p "$CAMINHO_DESTINO"
        echo "$CONTA_DESTINO diretório destino criado" >> $REGISTROS_DE_ATIVIDADE
        sleep 0.1
        cp -rp  "$CAMINHO_ORIGEM"/* $CAMINHO_DESTINO
        printf "\r Enviando arquivos de: $CAMINHO_ORIGEM para $CAMINHO_DESTINO "

else

        sleep 0.1
        echo "Cópia de $CONTA_ORIGEM para $CONTA_DESTINO feita com sucesso." >> $REGISTROS_DE_ATIVIDADE
        cp -rp "$CAMINHO_ORIGEM"/* $CAMINHO_DESTINO
        printf "\r Enviando arquivos de: $CAMINHO_ORIGEM para $CAMINHO_DESTINO "

        fi

}


valida_caminho
