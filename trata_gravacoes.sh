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
DIR_ENTRADA="/home/extend/gravacoes_caesb/receptivo"
DIR_ENTRADA_BRB="/home/extend/gravacoes/receptivo"

############################################
# Esta variavel define o destino para onde
#as gravacoes serao enviadas de acordo com a data
DIR_DESTINO="/home/gravacoes/brb_caesb/"
FILE=$1

###########
# esta variavel serve para definir a porcentagem
# limite de disco considerada critica para o script
# continuar, caso esse valor em disco seja atingido
# o script ira parar.
LIMITE=90

# tempo em segundos para descanso entre funcoes
# util para debugar com bash -x
DESCANSO=0

##########################################################
# Esta funcao ira ler a lista de gravacoes e procurar na
# variavel configurada em DIR_ENTRADA
procura(){

for LINHA in $( tac $FILE)
do
        GRAVACAO=$( echo $LINHA | awk -F "_" {'print $1'} )
        DIRETORIO=$( echo $LINHA | awk -F "_" {'print $2'} )
        echo "Procurando..."
        LOCALIZADA=$( find "$DIR_ENTRADA"/"$DIRETORIO"/ -iname $GRAVACAO*  2> /dev/null )
        echo  find "$DIR_ENTRADA"/"$DIRETORIO"/ -iname $GRAVACAO*
        if [ -z "${LOCALIZADA}" ]; then
                LOCALIZADA=$( find "$DIR_ENTRADA_BRB"/"$DIRETORIO"/ -iname $GRAVACAO*  2> /dev/null )
                echo  find "$DIR_ENTRADA_BRB"/"$DIRETORIO"/ -iname $GRAVACAO*
        fi
        valida_procura
        dorme
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



######## # Descomente a linha abaixo para gerar lo
 echo "$LINHA" >> /home/extend/scripts/script_de_gravacao/gravacao_nao_localizada

        edita_lista

else
          for arquivo in  ${LOCALIZADA[*]}
          do
                 echo "copiando $arquivo"

                 DIRETORIO_FINAL="$DIR_DESTINO""$DIRETORIO"

                 copia_arquivos

######## # Descomente a linha abaixo para gerar log
echo "$LINHA" >> /home/extend/scripts/script_de_gravacao/gravacao_localizada

                edita_lista

                 # essa variavel serve para verifcar o espaco em disco a cada copia feita
                 # serve para garantir que o disco nao ira topar.

                 DISCO_AGORA=$( df -h | grep /dev/sda3 | awk {'print $5'} | tr -d % )

                 dorme

                 verifica_disco

         done
          fi
}
#########################################################################
# esta funcao serve para validar se a variavel DISCO_AGORA nao esta
# atingindo o limite especificado

verifica_disco(){

if [ "$DISCO_AGORA" -eq "$LIMITE" ]

then
        echo " Limite atingido. "
        exit 0
else
        echo "Disco o.k"
fi

}

#############################################
# funcao responsavel pela copia dos arquivos
# para o destino final

copia_arquivos(){

        mkdir -p "$DIRETORIO_FINAL"
dorme
        cp -rpv "$arquivo" "$DIRETORIO_FINAL"


}

######################################
# esta funcao serve para ocorrer pausas
# entre uma funcao e outra

dorme(){
        sleep "$DESCANSO"
}

###################################################
# Esta funcao ira deletar os arquivos que forem varridos
# independente se foram localizados ou nao
edita_lista(){

        sed -i "s/$LINHA//g" /home/extend/scripts/script_de_gravacao/lista_filtrada
}




        # Campo destinado a chamada de funcoes #
####################################################################

procura

###################################################################

