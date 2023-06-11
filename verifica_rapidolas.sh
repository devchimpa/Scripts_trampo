#!/bin/bash
#
#Desenvolvido por: DevChimpa 
#Data inicial: 11/06/2023

#Contato: 	
#https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
#https://github.com/devchimpa/
#
#######################################################################
#
resume_programa(){
	
	
echo "

Este script serve para trazer uma verificação básica
da máquina de maneira mais rápida, permitindo ser utilizada
em um único comando e em multi-ssh para verificar várias
máquinas ao mesmo tempo.
##Este script deve ser utilizado com privilégios Root.##
"

}
########################################################################
#
############## Siga o modelo abaixo caso mexa no script: ###############
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

read_only(){

touch /home/testefeito
if [ $? -ne 0 ]
then
	echo " Algo deu errado... "
else
	echo " Não está read-only " 
fi 
#ls /home/testefeito

}


desenha_macaco(){
echo "############################################################"
echo "           ------------------------------------------------"
echo "           $1  						"
echo "         /-------------------------------------------------"
echo "        /   
     /~\ 
   C(o o)D   -----
    _(^)   /    /
   /__m~\m/____/ "
echo "############################################################"
}

desenha_macaco2(){
echo "############################################################"
echo "           -----------------------------------------------"
echo "         	$1               			       "
echo "         /------------------------------------------------"
echo "        /   
     /~\ 
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "###########################################################"
}


verifica_geral(){

clear
	
echo "###########################################################"
DIA=$(date +%Y-%m-%d) 
HORA=$(date +%H:%M)

echo "Verifique se a data e hora está correta: $DIA $HORA"


echo "###########################################################"

echo "###########################################################"
echo "		Verifique os discos.			"
echo "###########################################################"
df -h | grep -v /dev/loop
echo "###########################################################"
echo "		Verifique os Inodes.			"
echo "###########################################################"
df -ih | grep -v /dev/loop

echo "###########################################################"
echo "		Verifque se está read-only:		"

			read_only

echo "###########################################################"	
echo " A arquitetura do sistema é: "
arch
echo "###########################################################"	
MAQUINA_VIRTUAL=$(lspci | grep -i vm | wc -l)
#echo $MAQUINA_VIRTUAL

if [ "$MAQUINA_VIRTUAL" -eq 0 ]
then 
	echo "          Esta é uma máquina física"
else
	echo "          Esta é uma máquina virtual."
fi

echo "###########################################################"
echo "Este é um debian: " 
cat /etc/debian_version
echo "###########################################################"	


}


verifica_geral




