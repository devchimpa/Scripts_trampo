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
# Este script ira verificar se as chamadas estao zeradas em horario
# comercial, caso esteja ira registrar o horario ate a proxima
# verificacao. E tomar decisao com base nesses dados.
#
#########-VARIAVEIS IMPORTANTES: #########################################


# A chave esta ofuscada para não ocorrer identificação por meio de regex.
CHAVE=$( echo "L2V4dCEwMHgK" | base64 -d )

SERVIDORES="10.20.1.45 10.20.1.44 "

TENTATIVA=0

# define o horario que o script iniciou
# e o momento que foi identificado uma ura zerada
TIME_STAMP_INICIAL=$( date +%s )

# define o tempo de espera em segundos
TEMPO_ESPERA=60

############- FUNCOES -#######################################################


verifica_chamadas(){
# Esta funcao serve para executar o comando no servidor
# alvo e colher o resultado para tomada de acoes.

for maquina in ${SERVIDORES[*]}

do

QUANTIDADE=$( sshpass -p "$CHAVE" ssh -t root@"$maquina" 'comunix -rx "core show channels"' | grep Dial | wc -l )


NOME_MAQUINA=$( sshpass -p "$CHAVE" ssh "$maquina" 'hostname' )

#echo " $maquina: $QUANTIDADE $NOME_MAQUINA "

valida_quantidade

done

}


valida_quantidade(){

        if [ "$QUANTIDADE" -eq 0 ]
then

        echo " $maquina: $QUANTIDADE $NOME_MAQUINA "

        MAQUINA_ZERADA+=( "$maquina" )

        fi


}

verifica_zeradas(){

        if [ -z "$MAQUINA_ZERADA" ]
then
        exit 0

else


        for maquina in ${MAQUINA_ZERADA[*]}

do

        QUANTIDADE=$( sshpass -p "$CHAVE" ssh -t root@"$maquina" 'comunix -rx "core show channels"' | grep Dial | wc -l )

        NOME_MAQUINA=$( sshpass -p "$CHAVE" ssh "$maquina" 'hostname' )

echo " $NOME_MAQUINA $QUANTIDADE "

        validar_normalidade
        verifica_zeradas

        done

fi

}


aguarda(){
# esta funcao serve para fazer uma pausa antes
# de realizar uma nova acao.

sleep "$TEMPO_ESPERA"

}

validar_normalidade(){

if [ "$QUANTIDADE" -ne 0 ]

then
        exit 0

else
         TIME_STAMP_FINAL=$( date +%s )

         TEMPO_FORA=$( expr "$TIME_STAMP_FINAL" - "$TIME_STAMP_INICIAL" )

        echo "$maquina sem chamadas há $TEMPO_FORA segundos. "

        aguarda

        fi


}

########### - CHAMADA DE FUNCOES - #############################################

verifica_chamadas
verifica_zeradas
