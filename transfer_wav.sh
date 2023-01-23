#!/bin/bash

#################################################################################
# Script shell para rastrear midias EPOCH                                       #
# Organizar nos respectivos diretorios AA-MM-DD                                 #
#                                                                               #
#by  Pablo Pinheiro                                                             #
#                                                                               #
#################################################################################
# PARA UTILZAR O SCRIPT É PRECISO MUDAR AS VARIÁVEIS ABAIXO:
# CAMINHO_ORIGEM E DESTINO_ENVIO
# 
# O SCRIPT VAI BUSCAR AS GRAVACOES NO CAMINHO DE ORIGEM.
# UM CAMINHO COMO EXEMPLO É O /home/extend/gravacoes E ENVIAR PARA O LOCAL DE BACKUP
# CONFIGURADO NA VARIÁVEL DESTINO ENVIO.
# O SCRIPT VAI IDENTIFICAR A URA DE ORIGEM DA GRAVAÇAO E ORGANIZAR POR NÚMERO DE URA
# E DATA.
#
################################VARIAVEIS########################################

CAMINHO_ORIGEM="/home/backups/gravacoes/"
DESTINO_ENVIO="/home/backups/gravacoes/"


################################################################################


##############################################################################
# Modificado por: DevChimpa						     #
# Data: 21/01/2023							     # 	
# Contato: chimpadeveloper@gmail.com					     #	
#	  https://github.com/devchimpa/					     #
#									     #
##############################################################################


cd "$CAMINHO_ORIGEM"

for gravacoes in */*.WAV
  do
	#Para separar por formato
	FORMATO="$(echo $gravacoes | cut -d "/" -f 2 | cut -d "." -f 2)"
	#echo "$FORMATO"

	#Para separar o campo em Unique ID
	UNIQUEID="$(echo $gravacoes | cut -d '/' -f 2 | cut -d '.' -f 1)"
	#echo $UNIQUEID

	#Separa a gravção por período em timestamp
	TEMPORIZADOR="$(echo "$UNIQUEID" | cut -c 3-12 )"
	#echo "$TEMPORIZADOR"
	
	#Nome e origem completa do arquivo
	ARQUIVO="$gravacoes"
	echo "$ARQUIVO"
	
	#Ura de Origem de acordo com os dois primeiros dígitos do unique ID
	ORIGEM_GRAVACAO="$( echo $UNIQUEID | cut -c 1-2 )"
	echo "$ORIGEM_GRAVACAO"

	#Pasta destino de acordo com o timestamp retirado na variável Temporizador
	DATA_DESTINO="$(date +%Y-%m-%d -d @"$TEMPORIZADOR")"
	#echo "$DATA_DESTINO"
	
	#date -d @"$TEMPORIZADOR" "$@"


	#echo " A gravação: "$UNIQUEID" pertence a Ura"$ORIGEM_GRAVACAO do dia: "$DATA_DESTINO"
	#sleep 1
	

	if [ ! -d $"DESTINO_ENVIO"URA"$ORIGEM_GRAVACAO" ]
	then
		mkdir -p "$DESTINO_ENVIO"URA"$ORIGEM_GRAVACAO"
		
		DESTINO_INICIAL=""$DESTINO_ENVIO"URA"$ORIGEM_GRAVACAO""
		
		else
		
			DESTINO_INICIAL=""$DESTINO_ENVIO"URA"$ORIGEM_GRAVACAO""

			#echo "Já existe."	
	fi

		if [ ! -d "$DESTINO_INICIAL"/"$DATA_DESTINO" ] 
		then
		       mkdir -p "$DESTINO_INICIAL"/"$DATA_DESTINO"
		DESTINO_FINAL=""$DESTINO_INICIAL"/"$DATA_DESTINO""	       
	       
	       else
			DESTINO_FINAL=""$DESTINO_INICIAL"/"$DATA_DESTINO""	       
		fi
	
		cp -rpv "$ARQUIVO" "$DESTINO_FINAL"

done
