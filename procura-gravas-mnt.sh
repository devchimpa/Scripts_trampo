#!/bin/bash

#Desenvolvido por: Rodrigo Pinheiro
#Data inicial: 05/03/2024

#Contato:
#https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
#https://github.com/devchimpa/
#
#
#
# COMO FUNCIONA:
# Para executar o script devem ser montados os volumes contendo as
# gravações com o nome: /mnt.
# Os uniqueids devem ser colocados dentro de: /home/lista_de_procuradas.
# Após isso, basta rodar o script.
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

# diretorio teste
NOME_DIRETORIO="/home/teste-gravacoes"

#NOME_DIRETORIO="mnt"

DIRETORIOS="/home/teste-gravacoes"
#DIRETORIOS=$( df -h | grep $NOME_DIRETORIO | awk '{print $6}' )



##########################################################################
#                           CORPO DO SCRIPT:                             #
##########################################################################

edita_arquivo()
        {

        echo " Editando a lista de gravações "
        sed -i "s/$i//g" /home/lista_de_procuradas
        sleep 1
        echo " Lista de gravações editada. "
        sleep 1
}


procura_lista()
        {
         for i in $( cat /home/lista_de_procuradas )
         do
         PROCURADA=$( find $1 -iname $i )

         if [ -z "$PROCURADA" ]
         then
                 echo "$i Não localizada."
         else
                for GRAVA in ${PROCURADA[*]}
                do
         cp -rpv "$GRAVA" /home/gravacoes/localizadas
         echo "$GRAVA localizada" >> /home/gravacoes/localizadas/lista-encontradas
         sleep 1
         edita_arquivo
                done
                fi

        done
        }

for PONTO_DE_MONTAGEM in ${DIRETORIOS[*]}
do
        procura_lista "$PONTO_DE_MONTAGEM"
done

