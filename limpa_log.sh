#!/bin/bash
##############################################################################
#                                                                            #
# criado por: Rodrigo Pinheiro                                               #
# Comunix Tecnologia                                                         #
# Data: 07/12/2023                                                           #
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
#       O objetivo do script é fazer um limpa do diretório:                #
#       /home/extend/log                                                   #
#       E remover os arquivos de log que tem mais de 24h.                  #
#       Esta ação é feita com o comando "find -ctime +1"                   #
#       Este script pode ser modificado para ser utilizado em              #
#       em outros locais, bastando modificar as variáveis:                 #
#       DIRETORIO_A_LIMPAR e DIAS_MAIOR_QUE                                #
#                                                                          #
#       É importante que o script rode todos dias 00h00                    #
#       Para agendá-lo no crontab:                                         #
#       0 0 * * * /home/extend/scripts/limpa_log.sh                        #
#                                                                          #
#                                                                          #
#                                                                          #
############################################################################
############################################################################

# BOAS PRÁTICAS:

# VARIÁVEIS DEVEM SER DECLARADAS COM LETRAS MAIÚSCULAS

# VARIÁVEIS DEVEM TER NOMES CLAROS COMO POR EXEMPLO: "PID_DO_PROCESSO"

# FUNÇÕES DEVEM SER DECLARADAS COM LETRAS minúsculas

# FUNÇÕES DEVEM TER NOMES CLAROS COMO POR EXEMPLO: "localiza_arquivo"

# COMENTÁRIOS SÃO SEMPRE BEM VINDOS.

# Lembre-se, manter uma boa prática ajuda na manutenção e leitura do código.

#################################################################################
# CASO MEXA NESSE SCRIPT OU TENHA ALGUMA MELHORIA, SEGUIR O MODELO DO CAMPO ABAIXO:

# NOME:

# DATA DE MODIFICAÇÃO:

# O QUE FOI MODIFICADO:

#######################---VARIÁVEIS IMPORTANTES----#############################

# Esta variável guarda o diretório onde será feita a limpeza.
DIRETORIO_A_LIMPAR="/home/extend/log/"


# Esta variável indica que arquivos com mais de um dia serão apagados.
# Ela deve ser declarada desta maneira: "-1", assim arquivos com até 24 serão apagados
DIAS_MAIOR_QUE="-1"

################################################################################


if [ -d $DIRETORIO_A_LIMPAR ]

        then

                # Esta linha será substituida por um rm -r
find $DIRETORIO_A_LIMPAR -ctime $DIAS_MAIOR_QUE | xargs -i rm -r {}

else
        echo " Diretório não existe."

fi
