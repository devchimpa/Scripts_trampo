#!/bin/bash
#
##############################################################################
# Criado por: Rodrigo Pinheiro                                               #
# Comunix Tecnologia                                                         #
# Data: 19/06/2023                                                           #
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
#       O OBJETIVO DO SCRIPT É PERCORRER AS PASTAS A PARTIR DO DIRETÓRIO   #
#       CONFIGURADO E VERIFICAR AS DATAS PARA ORGANIZAR                    #
#       AS GRAVACOES NO LOCAL CORRETO                                      #
#                                                                          #
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

##################################################################################



##################################################################################

# CASO MEXA NESSE SCRIPT OU TENHA ALGUMA MELHORIA, SEGUIR O MODELO DO CAMPO ABAIXO:

# NOME:

# DATA DE MODIFICAÇÃO:

# O QUE FOI MODIFICADO:

###############################################################################

#######################--VARIÁVEIS IMPORTANTES-----#############################


DIRETORIO_ORIGEM="/home/gravacoes/receptivo/backup/2023-06-18"

DIRETORIO_DESTINO="/home/gravacoes/receptivo/backup"



###############################################################################

cria_diretorio(){
        if [ ! -d $DIRETORIO_DESTINO ]
        then
        echo "Não existe."
        else
        VALIDA=1
        #echo "$DIRETORIO_DESTINO"/"$DATA_DE_ORIGEM"
fi
}

compara_datas(){

        if [ "$DIRETORIO_DO_ARQUIVO" != "$DATA_DE_ORIGEM" ]

        then
                echo "$GRAVACAO no local errado. Local correto: $DATA_DE_ORIGEM "
        else
                VALIDA=1
        fi
        cria_diretorio
}



descobre_data(){


TIMESTAMP=$( echo "$1" | cut -c 3-12 )

DATA_DE_ORIGEM=$( date -d @"$TIMESTAMP" +%Y-%m-%d )


}




varrer_diretorio() {

#esta função vai varrer o diretório configurado e definir as variáveis a serem usadas nas funções.

         DIRETORIO_A_VARRER=$1

    # Loop para percorrer os arquivos e diretórios no diretório atual
    for ARQUIVO in "$DIRETORIO_A_VARRER"/*; do
        if [ -d "$ARQUIVO" ]; then

            # Se for um diretório, chama a função recursivamente
            varrer_diretorio "$ARQUIVO"

        elif [ -f "$ARQUIVO" ]; then
        # Se for um arquivo, faça:

        GRAVACAO=$( echo "$ARQUIVO" | tr "/" " " | rev | awk {'print $1'} | rev )

        DIRETORIO_DO_ARQUIVO=$( echo "$ARQUIVO" | tr "/" " " | rev | awk {'print $2'} | rev )

        descobre_data $GRAVACAO
#       echo " diretorio: $DIRETORIO_DO_ARQUIVO "
#       echo " DATA ORIGE: $DATA_DE_ORIGEM "
        compara_datas

        fi
    done
}


varrer_diretorio $DIRETORIO_ORIGEM
