#!/bin/bash

GRAVACAO=$1

compara(){

  LOCALIZADO=$( echo $1 | tr "/" " " | rev | awk '{ print $1 }' | rev )
  if [ "$GRAVACAO" = "$LOCALIZADO" ]
then
  echo "$1 ACHOU!"
fi
}


procura(){

  DIRETORIO_A_VARRER=$1

  for arquivo in "$DIRETORIO_A_VARRER"/*
do
  if [ -f "$arquivo" ]
  then
  compara $arquivo
elif [ -d "$arquivo" ]
then
    procura $arquivo
  fi

done

  }

procura /home/user
