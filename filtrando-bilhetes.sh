#!/bin/bash
#
# Script feito com o objetivo de acelerar o processo
#de inserir bilhetes de chamadas no banco.
#
#informacoes importantes sobre o que o script  faz...
#
# 1 - ele vai pegar o arquivo da pasta de backup 
# 2 - mandar para a tmp
# 3 - descompactar
# 4 - dar um grep para saber se tem bilhete.
# 5 - vai pegar os bilhetes e transformar em txt
# 6 - pegar os bilhetes do txt e cortar na parte do insert
# 7 - remover a pasta, o tar.gz e tar da pasta /tmp
# 8 - fim do script
#
#
#
#Desenvolvido por: DevChimpa 
#Data: 10-01-2023
#Contato: chimpadeveloper@gmail.com
#https://github.com/devchimpa/
#
########################################################################
#
# Siga o modelo abaixo caso mexa no script: ############################
#
#Modificado por:        
#Data:
#Contato:
#Modificação feita:
#
##########################################################################



###########################################################################
#FUNÇÕES
###########################################################################


CAMINHO_ORIGEM="/home/backups/"
#CAMINHO_ORIGEM="/home/extend/calls/backup/"


LOG="/tmp/log_bilhete_chimposo.txt"
#ls  $CAMINHO_ORIGEM


testa_bilhete(){
	cat /tmp/listadebilhetes.txt
	sleep 2
	leitura_arquivo_bilhete=$(cat /tmp/listadebilhetes.txt)
	conta_arquivo_bilhetes=$(echo ${#leitura_arquivo_bilhete})	
	if [ $conta_arquivo_bilhetes -eq 0 ]
		then
			clear
			desenha_macaco "Este arquivo não é válido..."
			sleep 3
			echo "Arquivo inserido inválido. " >> $LOG
			echo $(date) >> "$LOG"
			remove_lixo
			exit

	fi
	}

remove_lixo(){
cd /tmp
	if [ -f /tmp/listadebilhetes.txt ] 
	then
		rm listadebilhetes.txt
	fi
	
	if [ -d /tmp/bilhetes ]
	then
		rm -r bilhetes
	fi
	
	if [ -f /tmp/grepbilhetes.txt ]
	then
		rm grepbilhetes.txt
	fi
	if [ -f /tmp/listadeentrada.txt ]
	then
		rm listadeentrada.txt
	fi
}

desenha_macaco(){
echo "##################################################"
echo "           --------------------------------------"
echo "           $1                                 "
echo "         /--------------------------------------"
echo "        /   
     /~\ 
   C(o o)D   -----
    _(^)   /    /
   /__m~\m/____/ "
echo "############################################################"
}

desenha_macaco2(){
echo "##################################################"
echo "           --------------------------------------"
echo "         	$1                                "
echo "         /--------------------------------------"
echo "        /   
     /~\ 
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "###########################################################"
}

Le_Entrada(){

echo "Ex: 2023-01-01.tar.gz , 2023-01-* 2023-01-0[1-5].tar.gz     "
echo "############################################################"

read ARQUIVO_ENTRADA


VALORENTRADA=$(echo ${#ARQUIVO_ENTRADA})
if [ $VALORENTRADA -eq 0 ] 
	then 
		echo "Insira algum arquivo válido."
	
		exit
fi	
}


Le_filtro(){

echo "Ex: Conta - Ramal - Atendidas - Campanhas     "
echo "############################################################"
read FGREP 
ENTRADAGREP=$(echo ${#FGREP})
if [ $ENTRADAGREP -eq 0 ] 
	then
	       FILTRO_GREP=Insert
	else FILTRO_GREP="$FGREP"
	fi	     
}


cria_entrada_txt(){

echo "$ARQUIVO_ENTRADA" >> /tmp/listadeentrada.txt
}


separa_bilhetes(){

for listadearquivos in $(cat /tmp/listadeentrada.txt)
	do 
		ls $CAMINHO_ORIGEM | grep $listadearquivos >> /tmp/listadebilhetes.txt
	done
cat /tmp/listadebilhetes.txt

}
criar_pasta_destino(){
	if [ ! -d /tmp/bilhetes ] 
then	mkdir -p /tmp/bilhetes
CAMINHO_DESTINO="/tmp/bilhetes"	
else
CAMINHO_DESTINO="/tmp/bilhetes"	
fi }

				
			
copia_bilhetes(){

		desenha_macaco2 " Verificando..."
		testa_bilhete
		clear
		desenha_macaco "Iniciando..."
		sleep 2
for linha in $(cat /tmp/listadebilhetes.txt)
	do
		if [ -f "$CAMINHO_ORIGEM""$linha" ]
		then
			#CRIAR PASTA DE DESTINO
			criar_pasta_destino
				#COPIAR OS ARQUIVOS PRO DESTINO
			
				cd $CAMINHO_ORIGEM
	 			cp -rpuv $linha $CAMINHO_DESTINO
				cd $CAMINHO_DESTINO 
	
				echo "Desarquivando ..."
				sleep 2	
				tar -zxvf $linha
				rm $linha

				ARQUIVO_TAR=$(ls *tar)
				tar -xvf "$ARQUIVO_TAR"
				echo "Removendo tar..."
				rm "$ARQUIVO_TAR"
				sleep 2

				ARQUIVO_PASTA=$(ls )
				grep -ir $FILTRO_GREP >> /tmp/grepbilhetes.txt 

				echo "Filtrando Bilhetes"
				sleep 2
				cat /tmp/grepbilhetes.txt | awk -F "INSERT INTO" '{print "INSERT INTO"$2}' > /tmp/inserts.txt
					else
					echo "Arquivo Inválido, log armazenado na pasta /tmp"
					echo "Arquivo Inválido $linha" >> $LOG
			fi

	done

	clear
	remove_lixo
	desenha_macaco2 "Arquivo de Inserts em /tmp/inserts.txt"
}

###################################################################################################################
# PROGRAMA EXECUTANDO
###################################################################################################################

clear
remove_lixo
echo "Script iniciado: " >> "$LOG"
echo $(date) >> "$LOG"
ls $CAMINHO_ORIGEM
desenha_macaco "Insira os arquivos de Bilhetes."
Le_Entrada
clear

desenha_macaco2 "Insira o tipo de filtro."
Le_filtro
cria_entrada_txt

clear
separa_bilhetes
clear
copia_bilhetes

echo "Script finalizado: " >> "$LOG"
echo $(date) >> "$LOG"
