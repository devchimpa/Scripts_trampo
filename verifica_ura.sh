#!/bin/bash
#
# Desenvolvido por: Rodrigo Pinheiro
# Data de Criação: 21/08/2024

# Contato:
# https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
# https://github.com/devchimpa/
#
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################
#
# Este script monitora status dos sevidores VOIP via sshpass e traz
# o resultado.
# De acordo com cada resultado é realizada uma tomada de decisao.
#
########################################################################
#
# codigo_saida:   255 = problema no ssh, ou keygen
#                  6  = problema keygen
#                  1  = Comunix não está rodando
#                  0  = Comunix está rodando
#
#########-VARIAVEIS IMPORTANTES: #########################################


# A chave esta ofuscada para não ocorrer identificação por meio de regex.
CHAVE=$( echo "L2V4dCEwMHgK" | base64 -d )

# configuracao do tempo de espera em segundos.
TEMPO_ESPERA=60

SERVIDORES="192.168.2.101 192.168.1.38 "


TENTATIVA=0

############- FUNCOES -#######################################################


verifica_status(){
# Esta funcao serve para executar o comando no servidor
# alvo e colher o resultado para tomada de acoes.

for maquina in ${SERVIDORES[*]}

do

RETORNO=$( sshpass -p "$CHAVE" ssh -t root@"$maquina" 'comunix -rx "core show uptime"' )

CODIGO_SAIDA=$( echo $? )

verifica_retorno

done

}


aguarda(){
# esta funcao serve para fazer uma pausa antes
# de realizar uma nova acao.

sleep "$TEMPO_ESPERA"

}


verifica_retorno(){
# Esta funcao ira verificar o retorno da
# funcao verifica_status e tomar uma decisao

# codigo_saida
if [ "$CODIGO_SAIDA" -eq 0 ]

then

        echo "UP"

elif [ "$CODIGO_SAIDA" -eq 1 ]

then
        SERVER_DOWN+=( "$maquina" )
#       echo "$maquina DOWN"
echo "${SERVER_DOWN[*]}"
else
        echo "Erro: $CODIGO_SAIDA"


fi

}

nova_tentativa(){

        if [ -z "$SERVER_DOWN" ]
        then
                exit 0

        else
                for maquina in ${SERVER_DOWN[*]}
                do

RETORNO=$( sshpass -p "$CHAVE" ssh -t root@"$maquina" 'comunix -rx "core show uptime"' )

CODIGO_SAIDA=$( echo $? )


if [ "$CODIGO_SAIDA" -ne 0 ]

then
        echo "$maquina $CODIGO_SAIDA"
        echo "$SERVER_DOWN"
else

SERVER_DOWN=( "${SERVER_DOWN[@]/$maquina}" )

fi

done

fi

TENTATIVA=$( expr "$TENTATIVA" + 1 )

aguarda

if [ "$TENTATIVA" -gt 9 ]

then
        exit 0

else
        nova_tentativa

        fi

}
########### - CHAMADA DE FUNCOES - #############################################

verifica_status
nova_tentativa
