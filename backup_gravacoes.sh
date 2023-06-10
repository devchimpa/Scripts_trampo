#!/bin/bash
#
##############################################################################
# Criado por: Rodrigo Pinheiro                                               #
# Comunix Tecnologia                                                         #
# Data: 24/01/2023                                                           #
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
#       O OBJETIVO DO SCRIPT É PERCORRER AS PASTAS A PARTIR DO DIRETÓRIO:  #
#       /home/gravacoes DOS STORAGES       BUSCAR AS GRAVAÇÕES             #
#       COM UM TEMPO SUPERIOR OU IGUAL A 90 DIAS E SALVAR EM UM BACKUP     #
#       PARA DESOCUPAR O ESPAÇO EM DISCO.                                  #
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

###############################################################################


#É o diretório de onde ele irá iniciar a busca por gravações.
DIRETORIO_ORIGEM=/home/chimpa/Documents/gravacoes/
#É o diretório para onde ele irá enviar as gravações localizadas.
DIRETORIO_DESTINO=/home/chimpa/Documents/gravacoes_antigas/
# Sempre termine a declaração do diretório inicial com "/"

NOVENTA_DIAS_ATRAS="$( date -d "-90 days" +%s )"


# esta é uma maneira de varrer o diretório de maneira recursiva
# recursiva porque ele sempre vai ser chamado enquanto estiver vendo pastas.
# O objetivo dessa varredura é localizar apenas as gravações. 
varrer_diretorio() {
    DIRETORIO_A_VARRER=$1

    # Loop para percorrer os arquivos e diretórios no diretório atual
    for ARQUIVO in "$DIRETORIO_A_VARRER"/*; do
        if [ -d "$ARQUIVO" ]; then
        	
            # Se for um diretório, chama a função recursivamente
            varrer_diretorio "$ARQUIVO"
        elif [ -f "$ARQUIVO" ]; then
        	
            # Se for um arquivo, faça:
            #echo "$ARQUIVO"
          GRAVACAO=$( echo "$ARQUIVO" | tr "/" " " | rev | awk {'print $1'} | rev )
          descobre_data "$GRAVACAO"
          
          
        fi
    done
}


cria_diretorio_e_move(){


mkdir -p "$DIRETORIO_DESTINO""$DATA_DE_ORIGEM"

sleep 1

cp -rpuv "$ARQUIVO" "$DIRETORIO_DESTINO""$DATA_DE_ORIGEM"
#mv -v "$GRAVACAO" "$DIRETORIO_DESTINO""$DATA_DE_ORIGEM"

}



testa_tres_meses(){

        # Este trecho vai receber da função 'descobre_data', o id da gravação e testar se tem
        # mais ou menos de 3 meses.

        if [ "$1" -lt "$NOVENTA_DIAS_ATRAS" ]  || [ "$1" -eq "$NOVENTA_DIAS_ATRAS" ]
        then

                echo "A gravação:" "$GRAVACAO" "é de:" "$DATA_DE_ORIGEM" "então é maior que noventa dias."
           	#Aqui estamos chamando a função para movimentar a gravação para o local correto.
           	cria_diretorio_e_move
                
                #echo "$GRAVACAO" "$DIRETORIO_DESTINO""$DATA_DE_ORIGEM"
               

        else
                echo "A gravação:" "$GRAVACAO" "é de" "$DATA_DE_ORIGEM" "então é menor que noventa dias."
       
        fi

}



descobre_data(){


TIMESTAMP=$( echo "$1" | cut -c 3-12 )

#echo "$TIMESTAMP"

DATA_DE_ORIGEM=$( date -d @"$TIMESTAMP" +%Y-%m-%d )

#date -d @"$TIMESTAMP" +%s
#echo "$GRAVACAO" "data de criação:" "$DATA_DE_ORIGEM"

testa_tres_meses "$TIMESTAMP"
	
}


verifica_disco(){

DISCO_UM=$(df -h | grep -v /dev/loop | grep -i chimpa | awk {'print $5'} | tr -d "%" )

echo "O Disco 01 está com: "$DISCO_UM"% De espaço utilizado."

if [ $DISCO_UM -gt 40 ]
 then
	echo "Disco cheio..."
	sleep 1
	echo "Iniciando o remanejamento..."
# Se o disco estiver cheio, ele inicia a varredura.	
varrer_diretorio $DIRETORIO_ORIGEM
	
else
	echo "Disco dentro do padrão esperado."
	sleep 1 
	echo "Encerrando o programa..."
	exit 0
fi

}

verifica_disco

