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

# servidores a serem monitorados:
SERVIDORES="10.20.1.45 10.20.1.44 "


# define o horario que o script iniciou
# e o momento que foi identificado uma ura zerada
TIME_STAMP_INICIAL=$( date +%s )

# define o tempo de espera em segundos
TEMPO_ESPERA=60
#
# quanto tempo em minutos antes de registrar log
TEMPO_DEFINIDO=1

# Variavel de contagem, se for maior
# que tempo definido, registra log
ATINGIU_LIMITE=0


# horario de trabalho, deve ser colocado
# da seguinte maneira 08_23
# 08 representa o horario de inicio
# 23 representa o fim de expediente
HORARIO_COMERCIAL="06_23"



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
# esta funcao ira quantificar o numero de chamadas
# caso seja igual a zero ele adiciona a uma
# lista de maquinas sem chamadas "MAQUINA_ZERADA"

        if [ "$QUANTIDADE" -eq 0 ]
then


        echo "$maquina com: $QUANTIDADE chamadas "

        MAQUINA_ZERADA+=( "$maquina" )
else
        echo "$maquina com: $QUANTIDADE chamadas "
        fi


}

verifica_zeradas(){
# esta funcao ira verificar se as maquinas
# que estao sem chamadas normalizaram
# caso nao, ele ira registrar e aguardar

        if [ -z "$MAQUINA_ZERADA" ]
then
        echo "0"
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
# Esta funcao valida se as maquinas sem chamadas
# normalizaram, caso nao ele registra o tempo
# para gerar log e aguarda

if [ "$QUANTIDADE" -ne 0 ]

then
        exit 0

else
         TIME_STAMP_FINAL=$( date +%s )

         TEMPO_FORA=$( expr "$TIME_STAMP_FINAL" - "$TIME_STAMP_INICIAL" )

        echo "$maquina sem chamadas há $TEMPO_FORA segundos. "

        ATINGIU_LIMITE=$( expr $ATINGIU_LIMITE + 1 )

        limite_atingido

        aguarda

        fi

}


limite_atingido(){
# esta funcao calcula o tempo limite em minutos que a maquina pode ficar
# sem chamadas, aqui sera gerado o log caso o limite seja atingido.

        if [ "$ATINGIU_LIMITE" -gt "$TEMPO_DEFINIDO" ]
then
        echo "$NOME_MAQUINA Há $TEMPO_FORA segundos sem chamadas."
        # Este ponto pode ser inserido una funcao de log
        exit 0

        fi

}


verifica_horario(){
#esta funcao verifica o horario comercial
# se estiver no horario, ele segue fluxo
# caso contrario, ele imprime n_verificar e sai

        HORA_ATUAL=$( date +%H )
        HORA_INICIAL=$( echo "$HORARIO_COMERCIAL" | awk -F "_" {'print $1'})
        HORA_FINAL=$( echo "$HORARIO_COMERCIAL" | awk -F "_" {'print $2'} )

        if [ "$HORA_ATUAL" -gt "$HORA_INICIAL" ] && [ "$HORA_ATUAL" -gt "$HORA_FINAL" ]
        then
                echo "0"
                exit 0

        else

        verifica_chamadas
          fi

}


########### - CHAMADA DE FUNCOES - #############################################
verifica_horario
#verifica_chamadas
verifica_zeradas
