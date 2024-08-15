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
# ARQUIVO_ENTRADA= Aqui deve ser definido o diretóri
procura(){
for LINHA in $( cat lista_gravacoes_filtradas )
do 
	GRAVACAO=$( echo $LINHA | awk -F "_" {'print $1'} )
	DIRETORIO=$( echo $LINHA | awk -F "_" {'print $2'} )
	echo "Procurando..."
	LOCALIZADA=$( find /home/chimpa/"$DIRETORIO"/ -iname $GRAVACAO )
	sleep 5
	valida_procura
done
}
valida_procura(){
	if [ "$LOCALIZADA" -z ]
	then
	 echo " $GRAVACAO não localizada."
 else
	  echo " Copiando $GRAVACAO "
	  fi
}
procura
