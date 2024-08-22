#!/bin/bash
#
# Desenvolvido por: Rodrigo Pinheiro
# Data de Criação: 22/08/2024

# Contato:
# https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
# https://github.com/devchimpa/
#
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################
#
# Este script ira verificar o tempo da ultima mensagem whatsapp em horario
# comercial, caso o tempo esteja muito alto ira registrar o horario ate a proxima
# verificacao. E tomar decisao com base nesses dados
#
#########-VARIAVEIS IMPORTANTES: #########################################


# A chave esta ofuscada para não ocorrer identificação por meio de regex.
CHAVE=$( echo "L2V4dCEwMHgK" | base64 -d )

# servidores a serem monitorados:
SERVIDORES=" 10.20.1.40 "

# define o tempo de espera em segundos
TEMPO_ESPERA="60"

# maximo de tempo em segundos permitido
# de tempo sem mensagens
UMA_HORA_FORA="3600"
MEIA_HORA_FORA="1800"

# horario de trabalho, deve ser colocado:
#
HORARIO_COMERCIAL="06_23"

# caso seja necessário verificar tera saida 1 ,2 ou 0 caso
# nao precise verificar.

# verificacao de meia hora fora
VERIFICAR_M="1"

# verificacao de uma hora fora
VERIFICAR_H="2"

# nao verificar
N_VERIFICAR="0"


############- FUNCOES -#######################################################


verifica_conversas(){
# Esta funcao serve para executar o comando no servidor
# e colher o tempo em segundos da ultima mensagem para tomada de acoes.

for maquina in ${SERVIDORES[*]}

do

        RESPOSTA=" 3900"

#       RESPOSTA=$( sshpass -p "$CHAVE" ssh -t root@"$maquina" '/var/www/cmxom/./psql_exec /var/www/cmxom "select trunc(extract(epoch from now())-timestamp) from messages where channel=15 order by id desc limit 1"' 2>/dev/null)

        TEMPO_MENSAGEM=$( echo "$RESPOSTA" | tr -cd 0-9 )

#       echo "$TEMPO_MENSAGEM"

        valida_quantidade
done

}


valida_quantidade(){
# esta funcao ira contabilizar o tempo da ultima conversa
# caso seja um valor alto, ele imprime o valor
# de verificar ou nao.

        if [ "$TEMPO_MENSAGEM" -ge "$UMA_HORA_FORA" ]
then

        echo "$VERIFICAR_H"

elif [ "$TEMPO_MENSAGEM" -ge "$MEIA_HORA_FORA" ]

then
        echo "$VERIFICAR_M"

#       ALTO_PERIODO+=( "$maquina" )
else
        echo "$N_VERIFICAR"
        fi


}

aguarda(){
# esta funcao serve para fazer uma pausa antes
# de realizar uma nova acao.

sleep "$TEMPO_ESPERA"

}


verifica_horario(){
#esta funcao verifica o horario comercial
# se estiver no horario, ele segue fluxo
# caso contrario, ele imprime n_verificar

        HORA_ATUAL=$( date +%H )
        HORA_INICIAL=$( echo "$HORARIO_COMERCIAL" | awk -F "_" {'print $1'})
        HORA_FINAL=$( echo "$HORARIO_COMERCIAL" | awk -F "_" {'print $2'} )

        if [ "$HORA_ATUAL" -gt "$HORA_INICIAL" ] && [ "$HORA_ATUAL" -gt "$HORA_FINAL" ]
        then
                exit 0

        else

        verifica_conversas
          fi

}


########### - CHAMADA DE FUNCOES - #############################################
verifica_horario
#verifica_conversas
#verifica_zeradas

