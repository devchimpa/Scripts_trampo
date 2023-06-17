#!/bin/bash
#
##############################################################################
# Criado por: Rodrigo Pinheiro                                               #
# Comunix Tecnologia                                                         #
# Data: 15/01/2023                                                           #
# Contato:                                                                   #
#         https://www.linkedin.com/in/rodrigo-pinheiro-214663206/            #
#         https://github.com/devchimpa/                                      #
#                                                                            #
##############################################################################
#
############################################################################
#                                                                          #
#       DESCRIÇÃO:                                                         #
#                                                                          #
#       O objetivo do programa é verificar se os arquivos                  #
#	foram camuflados com extensões diferentes e scanear para ver       #
#	se há vírus.				                           #
#                                                                          #
#                                                                          #
#                                                                          #
############################################################################

################################################################################

# BOAS PRÁTICAS:

# VARIÁVEIS DEVEM SER DECLARADAS COM LETRAS MAIÚSCULAS

# VARIÁVEIS DEVEM TER NOMES CLAROS COMO POR EXEMPLO: "PID_DO_PROCESSO" 

# FUNÇÕES DEVEM SER DECLARADAS COM LETRAS minúsculas

# FUNÇÕES DEVEM TER NOMES CLAROS COMO POR EXEMPLO: "localiza_arquivo" 

# COMENTÁRIOS SÃO SEMPRE BEM VINDOS.

# Lembre-se, manter uma boa prática ajuda na manutenção e leitura do código.

################################################################################                                                                                                                                                             #

# CASO MEXA NESSE SCRIPT OU TENHA ALGUMA MELHORIA, SEGUIR O MODELO DO CAMPO ABAIXO:

# NOME:

# DATA DE MODIFICAÇÃO:

# O QUE FOI MODIFICADO:

#########################################################
#	       TABELA DE CABEÇALHOS

#########################################################
#|   Tipo de arquivo    |    Assinatura hexadecimal    |#
#|----------------------|------------------------------|#
#|      JPEG            |    FF D8 FF E0               |#
#|      PNG             |    89 50 4E 47               |#
#|      GIF             |    47 49 46 38               |#
#|      PDF             |    25 50 44 46               |#
#|      ZIP             |    50 4B 03 04               |#
#|      RAR             |    52 61 72 21               |#
#|      MP3             |    49 44 33                  |#
#|      WAV             |    52 49 46 46               |#
#|      AVI             |    52 49 46 46               |#
#|      MP4             |    00 00 00 18 66 74 79 70   |#
#|      DOCX            |    50 4B 03 04 14 00 06 00   |#
#|      XLSX            |    50 4B 03 04 14 00 06 00   |#
#|      PPTX            |    50 4B 03 04 14 00 06 00   |#
#########################################################


###############-VARIAVEIS INICIAIS-######################


# Recebe o nome do arquivo que será testado como argumento
ARQUIVO_ENTRADA=$1

# Extrai a extensão do arquivo
EXTENSAO="${ARQUIVO_ENTRADA##*.}"

#Saída final do programa, caso dê errado, ou caso dê certo.
SAIDA_OK=1

SAIDA_NOK=0

####################-FUNCOES-#########################


# Esta função vai definir de acordo com a extensão
# qual a hexadecimal será guardado na variável
# para que posteriormente seja feita uma comparação do padrão.

# a variável Tabela_hexa foi transformada em uma lista pois o padrão hexa pode mudar,
# dessa maneira, só será necessário acrescentar um novo padrão para ser testado juntamente com
# os antigos padrões.

define_tabela(){

case "$1" in
 
	pdf|PDF)

		TABELA_HEXA=( '25504446' )
	
    	;;
	doc|docx|DOC|DOCX)

		TABELA_HEXA=( 'd0cf11e0'  '504b0304')
	
    	;;
	jpeg|jpg|JPG|JPEG)
    
		TABELA_HEXA=( 'ffd8ffe0' )
		
    	;;
	xls|xlsx|XLS|XLSX)
    
		TABELA_HEXA=( 'd0cf11e0' '504b0304')
	
    	;;
	mp3|MP3)
    
		TABELA_HEXA=( '494433' '52494646' '57415645' )
	
    	;;
	mp4|MP4)
    
		TABELA_HEXA=( '66747970' '00000018' )   

		
		;;
	png|PNG)
    
		TABELA_HEXA=( '89504e47' )
		
   	 ;;
  *)
   	deleta_arquivo 
	  echo $SAIDA_NOK
	  exit 
    ;;


esac

}


###############################################################################################################

# esta função serve para descobrir o cabeçalho hexadecimal do arquivo de entrada
# posteriormente este arquivo será comparado com a tabela

descobre_cabecalho(){

	ARQUIVO_HEXA=$(xxd -l 4 -p $1 | tr -d '\n' | tr '[:upper:]' '[:lower:]')
	
}


###############################################################################################################


compara_hexa(){

# Este laço for faz a leitura de cada item guardado em Tabela_hexa
	for HEXA in ${TABELA_HEXA[*]}
do
	#echo $HEXA

	#Se tabela for diferente do padrão, então 0
	if [ "$HEXA" != "$ARQUIVO_HEXA" ] 
	   then
		CONFIRMA_HEXA=0
	
	else
	
	# se for igual, soma 1. Resultado positivo

		CONFIRMA_HEXA=$( expr $CONFIRMA_HEXA + 1 )

	fi
done

}


confirma_saida(){

	# esta função serve para finalizar o laço compara_hexa
 
	if [ $CONFIRMA_HEXA != 1 ] 
	
	then
		deleta_arquivo 
		echo $SAIDA_NOK
		exit 
	else
		echo $SAIDA_OK

	fi


}

deleta_arquivo(){
	
	NADA=0
	# este ponto ainda não faz nada, só serve para
	# existir as funcionalidades para quando o programa ficar pronto

}


# Este campo é onde as funções são chamadas e recebem seus parâmetros de entrada.
###############################################################################################################

# Estas funções fazem parte do primeiro nível de filtros

descobre_cabecalho $ARQUIVO_ENTRADA
#echo $ARQUIVO_HEXA

define_tabela $EXTENSAO


compara_hexa


confirma_saida



###############################################################################################################

# programa ainda em confecção...
