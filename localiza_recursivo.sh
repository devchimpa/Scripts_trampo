#!/bin/bash

# Nesta primeira variável estamos passando o arquivo que queremos encontrar
GRAVACAO=$1

# Esta função servirá para comparar se o arquivo que ele achou é o mesmo que estamos procurando.
compara(){

  LOCALIZADO=$( echo $1 | tr "/" " " | rev | awk '{ print $1 }' | rev )
  if [ "$GRAVACAO" = "$LOCALIZADO" ]
then
  echo "$1 ACHOU!"
  exit 0
fi
}

# Esta função serve para varrer os diretórios que definimos como /home/user na última linha.
# Ele irá começar a procura a partir dali e irá procurar recursivamente em todos os diretórios.
procura(){
# A Função recebe o parâmetro /home/user
  DIRETORIO_A_VARRER=$1

  for arquivo in "$DIRETORIO_A_VARRER"/*
do
# Se for um arquivo ele verifica se é igual o que estamos procurando
  if [ -f "$arquivo" ]
  then
  # Se for um diretório ele entra no diretório e continua a varredura do que estamos procurando
  compara $arquivo
elif [ -d "$arquivo" ]
then
    procura $arquivo
  fi

done

  }

procura /home/user
