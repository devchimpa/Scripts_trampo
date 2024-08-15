#!/bin/bash
#
# Desenvolvido por: DevChimpa
# Data de Criação: 12/08/2024
# Contato:
# https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
# https://github.com/devchimpa/
#
#######################################################################
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################
#
# O objetivo deste programa é fazer a leitura dos arquivos de gravação
# e organizar de acordo com as respectivas datas.
#
#########################################################################

#################
# Esta variavel define onde as gravacoes
# serao procuradas
DIR_ENTRADA="/home/extend/gravacoes/receptivo"

############################################
# Esta variavel define o destino para onde
#as gravacoes serao enviadas de acordo com a data
DIR_DESTINO="/home/gravacoes/brb_caesb/"

###########
# esta variavel serve para definir a porcentagem
# limite de disco considerada critica para o script
# parar, caso esse valor em disco seja atingido
# o script ira parar.
LIMITE=80


##########################################################
# Esta funcao ira ler a lista de gravacoes e procurar na
# variavel configurada em DIR_ENTRADA
procura(){

for LINHA in $( cat lista_gravacoes_filtradas )
do
        GRAVACAO=$( echo $LINHA | awk -F "_" {'print $1'} )
        DIRETORIO=$( echo $LINHA | awk -F "_" {'print $2'} )
        echo "Procurando..."
        LOCALIZADA=$( find "$DIR_ENTRADA"/"$DIRETORIO"/ -iname $GRAVACAO* )
        sleep 5
        valida_procura
done
}

###############################################################
# Esta funcao ira validar se a gravacao foi localizada e
# realizar a copia, caso nao localize  devera gerar
# um log para que se saiba o que nao foi localizado.

valida_procura(){
        if [ -z "$LOCALIZADA" ]
        then
         echo " $GRAVACAO não localizada."
         # Descomente a linha abaixo para gerar log
         # echo "$LINHA" >> gravacoes_nao_localizadas
 else
          for arquivo in  ${LOCALIZADA[*]}
          do
                 echo copiando "$arquivo"
                 copia_arquivos "$arquivo"
                 # essa variavel serve para verifcar o espaco em disco a cada copia feita
                 # serve para garantir que o disco nao ira topar.

                 DISCO_AGORA=$( df -h | grep /dev/sda3 | awk {'print $5'} | tr -d % )

                 sleep 1

                 verifica_disco

         done
          fi
}
#########################################################################
# esta funcao serve para validar se a variavel DISCO_AGORA nao esta
# atingindo o limite especificado

verifica_disco(){

if [ "$DISCO_AGORA" -gt "$LIMITE" ]

then
        echo " Limite atingido. "
        exit 0
else
        echo "Disco o.k"
fi

}

copia_arquivos(){

        grava="$1"
        echo "copiando gravacao para:"

}


        # Campo destinado a chamada de funcoes #
####################################################################

procura

###################################################################
