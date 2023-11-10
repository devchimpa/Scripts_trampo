#!/bin/bash
#
#
#
##########################################################################################
#
# O objetivo deste script é buscar gravações dentro do diretório definido na função procura()
#
# O script funciona por meio de um laço for que vai fazendo a comparação para identificar
# se os arquivos localizados na varredura são os mesmos que solicitamos, caso seja
# ele irá registrar um log indicando a localização do arquivo.			
#
#
############################################################################################
#
#			 CONFIGURAÇÕES DO SCRIPT:
#		( utilize este campo para configurar o script)
#
#
#diretorio onde o script deve iniciar a busca:
DIRETORIO_DEFINIDO=/mnt2
#
#
LISTA_DE_BUSCAS=/home/lista_de_procuradas
#
#arquivo onde devem ser registradas gravacoes localizadas:
ARQUIVO_DE_LOG=/home/gravacao_localizada
#



############################## INICIO DO SCRIPT #############################################



# Esta função servirá para comparar se o arquivo que ele achou é o mesmo que estamos procurando.

compara(){

  LOCALIZADO=$( echo $1 | tr "/" " " | rev | awk '{ print $1 }' | rev )


for linha in $(cat $LISTA_DE_BUSCAS)
        do
        GRAVACAO=$linha

  if [ "$GRAVACAO" = "$LOCALIZADO" ]

  then
	echo "$1 achou!"
       	echo $1 >> $ARQUIVO_DE_LOG

	fi

done
}




# Esta função serve para varrer os diretórios que definimos para a busca.
# Ele irá começar a procura a partir dali e irá procurar recursivamente em todos os diretórios.

procura(){

# A Função recebe como parâmetro o diretorio
  DIRETORIO_A_VARRER=$1

  for arquivo in "$DIRETORIO_A_VARRER"/*
do
# Se for um arquivo ele verifica se este é igual o que estamos procurando
  if [ -f "$arquivo" ]
  then

  compara $arquivo

# se for um diretório, ele entra no diretório e continua a varredura.

elif [ -d "$arquivo" ]
then
    procura $arquivo
  fi

done

  }

procura $DIRETORIO_DEFINIDO
