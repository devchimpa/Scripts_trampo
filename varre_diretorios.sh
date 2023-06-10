#!/bin/bash
#
#Criado por: Rodrigo Pinheiro
#
#Contato: 	https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
#           https://github.com/devchimpa/
#
#######################################################################
#
#######################DESCRIÇÃO DO PROGRAMA###########################
# Este programa irá varrer diretórios de maneira recursiva
# é um modelo para ser usado em outros scripts
# ele serve para varrer diretórios até localizar um arquivo
# e tomar decisões caso este arquivo seja o desejado
#
#
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
			#FUNÇÕES MACACO#
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
####################################################################################
# VARIÁVEIS #
# insira aqui o diretório que deseja varrer
DIRETORIO="/home/gravacoes/"
#################################################################################



# esta é uma maneira de varrer o diretório de maneira recursiva
# recursiva porque ele sempre vai chamar a função enquanto estiver vendo pastas.
varrer_diretorio() {
    
    DIRETORIO_A_VARRER=$1

    # Loop para percorrer os arquivos e diretórios no diretório atual
    for ARQUIVO in "$DIRETORIO_A_VARRER"/*; do
        if [ -d "$ARQUIVO" ]; then # este -d representa diretório, este if está testando se o arquivo é um diretório
        	echo "$ARQUIVO"
            # Se for um diretório, chama a função recursivamente
            varrer_diretorio "$ARQUIVO"
        elif [ -f "$ARQUIVO" ]; then # -f é para testar se é um file, ou seja este trecho testa se é um arquivo mesmo.
        	echo "$ARQUIVO"
            # Se for um arquivo, faça: 
            
            #(substitua este bloco com o seu código)
            
            echo "Arquivo encontrado: $ARQUIVO"
        fi
    done
}

# Chama a função inicial para começar a varredura a partir do diretório especificado

varrer_diretorio $DIRETORIO






