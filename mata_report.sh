#!/bin/bash
#
#
#Desenvolvido por: DevChimpa 
#Data inicial: 26/05/2023

#Contato: 	
#https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
#https://github.com/devchimpa/
#
#######################################################################
#
resume_programa(){
	
	
echo "

Script para matar vários processos do Pentaho de uma só vez e reiniciar
o programa.

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

#Tentativas de encerramento dos processos serão de 3 vezes 
TENTATIVAS=0



ressuscita_pentaho(){


if [ -d /home/pentaho/pentaho-8/pentaho-server/ ]
then
	echo "-> Iniciando o processo do Pentaho-8... "
	sleep 1
	/home/pentaho/pentaho-8/pentaho-server/start-pentaho.sh start
	
	
elif [ -d /home/pentaho/biserver-4/biserver-ce/ ]
then 
	echo "-> Iniciando o processo do Biserver-4... "
	sleep 1
	/home/pentaho/biserver-4/biserver-ce/./start-pentaho.sh start
else
	echo "Não foi possível localizar o pentaho na /home..."
	echo "Por favor, verifique se há /home2..."
fi	

}

mata_pentaho(){


#CONTA_PROCESSO=$( ps aux | grep pentaho | wc -l  )
CONTA_PROCESSO=$( ps aux | grep pentaho | grep -v 'grep pentaho' | wc -l  )

if [ $CONTA_PROCESSO -gt 0 ] && [ $TENTATIVAS -lt 3 ]
then
	ps aux | grep pentaho | awk -F ' ' '{print $2}' | xargs -i kill -9 {}
	sleep 1 
	TENTATIVAS=$( expr $TENTATIVAS + 1 )
	echo "tentativa:" $TENTATIVAS
	mata_pentaho

	
elif [ $CONTA_PROCESSO -gt 0 ]

then
	echo "Foram feitas 3 tentativas de encerramento, mas não foi possível encerrar todos os processos..."
	echo "Por favor, verifique com a equipe responsável."
else
	
	echo "Nenhum processo do Pentaho rodando... "	
	sleep 1
	ressuscita_pentaho

fi


}

mata_pentaho
