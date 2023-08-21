#!/bin/bash
#Desenvolvido por: Rodrigo Pinheiro
#Data inicial: 21/08/2023

#Contato:
#https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
#https://github.com/devchimpa/
#
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################
#                                                                       #
#                                                                       #
# Este é um programa simples que serve apenas para acelerar a busca das #
# gravações em avi ou mkv.                                              #
# O objetivo é apenas acelerar o processo de busca para saber se existe #
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



#Gravacao a ser procurada
GRAVA=$1


#ID Data da gravacao, essa variavel pega o timestamp para capturar a data.
DATA_GRAVA=$( echo $GRAVA | cut -c 3-12 )

GRAVA_ID=$( echo $GRAVA | cut -c 1-12 )


#Esta variavel guarda o diretorio referente a data da gravacao
DIR_DATA=$( date -d @$DATA_GRAVA +%Y-%m-%d )

DIR_UM=/home/gravacoes/brb_call
DIR_DOIS=/home2/gravacoes/brb_call
DIR_TRES=/home3/gravacoes/brb_call


GRAVA_UM=$( ls $DIR_UM/$DIR_DATA 2>> /dev/null | egrep "$DATA_GRAVA" )
GRAVA_DOIS=$( ls $DIR_DOIS/$DIR_DATA 2>> /dev/null | egrep "$DATA_GRAVA" )
GRAVA_TRES=$( ls $DIR_TRES/$DIR_DATA 2>> /dev/null | egrep "$DATA_GRAVA" )

if [ ${#GRAVA_UM} -gt 0 ]
then

        echo
        echo "Gravação: $GRAVA_UM"
        echo "Encontrada em: $DIR_UM/$DIR_DATA "
        echo


elif [ ${#GRAVA_DOIS} -gt 0 ]
then
        echo
        echo "Gravação: $GRAVA_DOIS "
        echo "Encontrada em: $DIR_DOIS/$DIR_DATA "
        echo


elif [ ${#GRAVA_TRES} -gt 0 ]
then
        echo
        echo "Gravação: $GRAVA_TRES "
        echo "Encontrada em: $DIR_TRES/$DIR_DATA "
        echo

else
        echo " Gravação não localizada"
        fi

