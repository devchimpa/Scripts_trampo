#!/bin/bash

procura(){

caminho="/home/extend/gravacoes/receptivo/2025-05-""$DIA"

if [ -z "$caminho" ]; then
  echo "Uso: $0 <caminho-do-diretório>"
  exit 1
fi

find "$caminho" -type f -iname "*.wav" | grep -E '/[0-9]+\.WAV$' | while read -r arquivo; do
  stat --format="%s" "$arquivo"
done | awk '{total+=$1; count++} END {
  if (count > 0)
    printf "Média: %.2f MB (%d arquivos)\n", total/count/1024/1024,count;
  else
    print "Nenhum arquivo correspondente encontrado."
}'

}

contagem(){

SEQUENCIA=$( seq 1 31 )

for numero in ${SEQUENCIA[*]}

do

 NUMERO="0$numero"

DIA="${NUMERO:(-2):2}"

sleep 1

echo "procurando dia: $DIA"

procura

done

}

contagem
