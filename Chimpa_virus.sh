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
#       foram camuflados com extensões diferentes e scanear para ver       #
#       se há vírus.                                                       #
#                                                                          #
#                                                                          #
############################################################################
#
# MODO DE USO:
#
# ./check_extension.sh arquivo-a-ser-verificado.jpg
#
#
#############################################################################
#
# DEPENDENCIAS:
#
# O SCRIPT DEPENDE DA INSTALAÇÃO DO CLAMAV PARA EXECUTAR CORRETAMENTE.
# SCRIPT DE INSTALAÇÃO:
#
# https://raw.githubusercontent.com/devchimpa/Scripts_trampo/main/instala_arquivo_.sh
#
##################################################################################

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
#
#
#
# Esta tabela de cabeçalhos segue uma norma técnica
# internacional para identificação de arquivos
# por meio dela é validada a autenticidade dos arquivos no script.
# este padrão é declarodo por tipo de arquivo na variável TABELA_HEXA
#
#########################################################
#              TABELA DE CABEÇALHOS

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


###############-VARIAVEIS-INICIAIS-######################



# Recebe o nome do arquivo que será testado como argumento
ARQUIVO_ENTRADA=$1

# Extrai a extensão do arquivo
EXTENSAO="${ARQUIVO_ENTRADA##*.}"

#Saída final do programa, caso dê errado, ou caso dê certo.

SAIDA_OK=1

SAIDA_NOK=0

# Na variável SUSPEITOS é configurado o diretório onde
# os arquivos não permitidos serão armazenados.
# Diretório definido originalmente como:
# /home/extend/scripts/.arquivos_suspeitos"

SUSPEITOS="/home/extend/scripts/.arquivos_suspeitos"


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
        move_arquivo
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

# Este laço faz a leitura de cada item guardado em Tabela_hexa
        for HEXA in ${TABELA_HEXA[*]}
do
        #echo $HEXA

        #Se tabela for diferente do padrão, então 0
        if [ "$HEXA" != "$ARQUIVO_HEXA" ]
          #este ponto é somado 0 pois ainda não houve identificação com os itens da lista.
                then
                CONFIRMA_HEXA=$( expr $CONFIRMA_HEXA + 0 )

        else

        #Este ponto é somado 1, pois um dos itens da lista corresponde ao cabeçalho

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
                #neste ponto o antivírus vai finalmente testar se o arquivo tem vírus
                #se houver, ele deverá guardar um retorno e imprimir 0 ou 1 ao final do programa.
                virus_scan

                verifica_saida_final

                fi


}


deleta_arquivo(){

        rm -r $ARQUIVO_ENTRADA
}



virus_scan(){

        clamdscan $ARQUIVO_ENTRADA --fdpass --no-summar 2>&1>> /dev/null
        #echo $?


}

verifica_saida_final(){

        SAIDA_COMANDO=$( echo $? )

        if [ $SAIDA_COMANDO != 0 ]
                then
        deleta_arquivo
        echo $SAIDA_NOK

else
        echo $SAIDA_OK

        fi

}

move_arquivo(){

        mkdir -p "$SUSPEITOS"
        sleep 0.5
        mv "$ARQUIVO_ENTRADA" "$SUSPEITOS"
}



# Este campo é onde as funções são chamadas e recebem seus parâmetros de entrada.
###############################################################################################################

# Estas funções fazem parte do primeiro nível de filtros

descobre_cabecalho $ARQUIVO_ENTRADA
#echo $ARQUIVO_HEXA

define_tabela $EXTENSAO


compara_hexa

# esta função final está associada a três funções, ela confirma saída
# do hexa, se for verdadeira, ela chama o scan e em seguida verifica a saída Final.
# E assim encerra o programa.
confirma_saida



###############################################################################################################
