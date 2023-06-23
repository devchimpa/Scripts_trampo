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
Após isso, é só entrar nos servers WEB e debugar.

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




# Tentativas de encerramento dos processos serão de 3 vezes 
# esta variável é um contador, a cada tentativa ela será incrementada.
# quando chegar no valor estipulado o programa passa para a próxima etapa.

TENTATIVAS=0

# mata x vezes é quantidade de vezes estipuladas para o programa tentar matar os processos.

MATA_X_VEZES=3




# esta função irá ser chamada apenas se não houver processo do pentaho rodando

ressuscita_pentaho(){

# este trecho verifica se existe o diretório pentaho 8
# se houver, ele inicia.

if [ -d /home/pentaho/pentaho-8/pentaho-server/ ]
then
	echo "-> Iniciando o processo do Pentaho-8... "
	sleep 1
	/home/pentaho/pentaho-8/pentaho-server/start-pentaho.sh start
	
# este trecho irá verificar se existe o diretório biserver-4
# se houver ele inicia
	
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


# esta função é a principal do programa
# ela vai contar os processos do pentaho e dar um kill -9 em cada um

mata_pentaho(){

# este trecho faz a contagem dos processos

CONTA_PROCESSO=$( ps aux | grep pentaho | grep -v 'grep pentaho' | wc -l  )

# este trecho compara se a quantidade de processos é maior do que 0
# e verifica se a tentativas de Kill foi esgotada

if [ $CONTA_PROCESSO -gt 0 ] && [ $TENTATIVAS -lt $MATA_X_VEZES ]
then
	ps aux | grep pentaho | awk -F ' ' '{print $2}' | xargs -i kill -9 {}
	sleep 2 
	TENTATIVAS=$( expr $TENTATIVAS + 1 )
	echo "tentativa:" $TENTATIVAS
	mata_pentaho

# se ainda assim houver processos, ele encerra o programa sem prosseguir
# Se esta condição for atendida ele não irá iniciar o processo do pentaho
	
elif [ $CONTA_PROCESSO -gt 0 ]

then
	echo "Foram feitas $MATA_X_VEZES tentativas de encerramento, verifique novamente..."
	echo "Caso continue falhando, verifique com a equipe de banco..."

else
	
	echo "Nenhum processo do Pentaho rodando... "	
	sleep 1
	ressuscita_pentaho

fi


}

# este trecho seve para chamar a função que vai controlar todo o fluxo do programa.

mata_pentaho

