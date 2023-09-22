#!/bin/bash

#Desenvolvido por: Rodrigo Pinheiro
#Data inicial: 21/08/2023

#Contato:
#https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
#https://github.com/devchimpa/
#
#
#
# COMO FUNCIONA:
# você deve acionar o script com o comando e passando o ID da gravação
# desta maneira:
#
#./localiza_id 1616944556284153.AVI
#
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################
#                                                                       #
#                                                                       #
# Este é um programa simples que serve apenas para acelerar a busca das #
# gravações em avi ou mkv.                                              #
# O programa trabalha basicamente com ls e grep                         #
# objetivo é apenas acelerar o processo de busca para saber se existe   #
# ou não o arquivo.                                                     #
#                                                                       #
#########################################################################
#
#
# Este é um programa colaborativo, caso tenha melhorias a acrescentar, sinta-se
# a vontade para mexer, apenas siga o modelo abaixo informando o que foi feito.
#
#
############## Siga o modelo abaixo caso mexa no script: ###############
#
#
#Modificado por:
#Data:
#Contato:
#Modificação feita:
#
#
##########################################################################
#                       VARIAVEIS PRINCIPAIS:                            #
##########################################################################


#Gravacao recebida pelo programa para ser procurada:
GRAVA_RECEBIDA=$1

# tratamento da gravação para remover as letras e ponto, deixando apenas o uniqueid
GRAVA=$( echo "$GRAVA_RECEBIDA" | tr -d aA-zZ | tr -d "." )

#Extensão variável irá guardar se é AVI ou MKV
EXTENSAO=$( echo "$GRAVA_RECEBIDA" | tr -d 0-9 | tr -d "." )

#Extrair o ID que representa a data da gravação
DATA_GRAVA=$( echo $GRAVA_RECEBIDA | cut -c 3-12 )

#GRAVA_ID=$( echo $GRAVA | cut -c 1-12 )
#echo $GRAVA_ID

DIR_DATA=$( date -d @"$DATA_GRAVA" +%Y-%m-%d )
#echo $DIR_DATA

#Estes são os diretórios onde serão feitas as buscas
DIR_UM=/home/gravacoes/brb_call
DIR_DOIS=/home2/gravacoes/brb_call
DIR_TRES=/home3/gravacoes/brb_call


#===================FUNCIONAMENTO DO PROGRAMA========================================#

compara_id(){


        if [ "$GRAVA" == "$1" ]
        then
                echo "igual!"
                fi

}


#função para verificar onde está a gravação e salvar em uma variável.
localiza_grava(){

GRAVA_UM=$(ls $DIR_UM/$DIR_DATA 2>> /dev/null | cut -d "_" -f 3 | tr -d aA-zZ | tr -d "." 2>> /dev/null | grep "$GRAVA")
GRAVA_DOIS=$( ls $DIR_DOIS/$DIR_DATA 2>> /dev/null | cut -d "_" -f 3 | tr -d aA-zZ | tr -d "." 2>> /dev/null | grep "$GRAVA" )
GRAVA_TRES=$( ls $DIR_TRES/$DIR_DATA 2>> /dev/null | cut -d "_" -f 3 | tr -d aA-zZ | tr -d "." 2>> /dev/null | grep "$GRAVA" )

}

localiza_grava



compara_gravas(){
        if [ ${#GRAVA_UM} -gt 0 ]
then

        echo
        echo "Gravação: $GRAVA_UM encontrada!"
        ls $DIR_UM/$DIR_DATA | grep $DATA_GRAVA
        echo


elif [ ${#GRAVA_DOIS} -gt 0 ]
then

        echo
        echo "Gravação: $GRAVA_DOIS encontrada! "
        ls $DIR_DOIS/$DIR_DATA | grep $DATA_GRAVA
        echo


elif [ ${#GRAVA_TRES} -gt 0 ]
then
        echo
        echo "Gravação: $GRAVA_TRES encontrada!"
        ls $DIR_TRES/$DIR_DATA | grep $DATA_GRAVA
        echo

else
        echo " Gravação não localizada"
        fi
}
compara_gravas
