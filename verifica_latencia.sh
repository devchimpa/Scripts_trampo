#!/bin/bash
#
#Desenvolvido por: DevChimpa 
#Data: 2023-06-23

#Contato: 	
#https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
#https://github.com/devchimpa/
#
#######################################################################
#
#######################DESCRIÇÃO DO PROGRAMA###########################
#
#O objetivo do programa é identificar oscilações no link da embratel
#oscilações no protocolo SIP
#O script funciona usando a função "sip show peers" do asterisk e registra
#na pasta /tmp com a nome e data do registro.
#
#
#
#
########################################################################
#
############## Siga o modelo abaixo caso mexa no script: ###############
#
# - Use letras maiúsculas para variáveis
# - Funções devem ter letras minúsculas
#
#
#Modificado por:        
#Data:
#Contato:
#Modificação feita:
#
##########################################################################



###########################################################################
			#FUNÇÕES#
###########################################################################


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

verifica_processo(){

NUMERO_DE_PROCESSOS=$( ps aux | grep $0 | grep -v "grep" | wc -l )

if [ "$NUMERO_DE_PROCESSOS" -gt 2 ] 
then
	desenha_macaco2 " Já existe processo rodando"
	#echo "$NUMERO_DE_PROCESSOS"
	exit 1
fi

}

#
##############################################################################################
		#VARIAVEIS#
###############################################################################################

DATA_DO_DIA=$( date +%d-%m-%y )
NOME_ARQUIVO="$DATA_DO_DIA"-"latencia-Embratel"

##############################################################################################
clear

verifica_processo

desenha_macaco " Arquivo salvo em: /tmp/$NOME_ARQUIVO"

watch -n 1 "date +%d-%m-%Y-%I:%M >> /tmp/$NOME_ARQUIVO ; asterisk -rx 'sip show peers' | grep -i embratel >> /tmp/$NOME_ARQUIVO"

