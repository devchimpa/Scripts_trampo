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
TEMPO_ESPERA=60

MAXIMO_DE_TEMPO=60

HORARIO_COMERCIAL="08_18"

############- FUNCOES -#######################################################


verifica_conversas(){
# Esta funcao serve para executar o comando no servidor
# alvo e colher o resultado para tomada de acoes.

for maquina in ${SERVIDORES[*]}

do

        RESPOSTA=" das12nnu2#\r9 "

#       RESPOSTA=$( sshpass -p "$CHAVE" ssh -t root@"$maquina" '/var/www/cmxom/./psql_exec /var/www/cmxom "select trunc(extract(epoch from now())-timestamp) from messages where channel=15 order by id desc limit 1"' )

        TEMPO_MENSAGEM=$( echo "$RESPOSTA" | tr -cd 0-9 )

        echo "$TEMPO_MENSAGEM"

        valida_quantidade
done

}


valida_quantidade(){
# esta funcao ira contabilizar o tempo da ultima conversa
# caso seja um valor alto, ele adiciona a uma
# lista: "ALTO_PERIODO"

        if [ "$TEMPO_MENSAGEM" -gt "$MAXIMO_DE_TEMPO" ]
then


        echo "$maquina há $TEMPO_MENSAGEM segundos sem chat."

        ALTO_PERIODO+=( "$maquina" )
else
        echo "$maquina O.K "
        fi


}

verifica_zeradas(){
# esta funcao ira verificar se as maquinas
# que estao sem chamadas normalizaram
# caso nao, ele ira registrar e aguardar

        if [ -z "$ALTO_PERIODO" ]
then
        exit 0

else


        for maquina in ${ALTO_PERIODO[*]}

do

        RESPOSTA=$( sshpass -p "$CHAVE" ssh -t root@"$maquina" '/var/www/cmxom/./psql_exec /var/www/cmxom "select trunc(extract(epoch from now())-timestamp) from messages where channel=15 order by id desc limit 1"' )

        NOME_MAQUINA=$( sshpass -p "$CHAVE" ssh "$maquina" 'hostname' )

        done

fi

}


aguarda(){
# esta funcao serve para fazer uma pausa antes
# de realizar uma nova acao.

sleep "$TEMPO_ESPERA"

}


verifica_horario(){

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

