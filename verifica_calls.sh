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

# horario comercial deve ser
# configurado da seguinte maneira: 08_23
# 08 representa o horario de inicio
# 23 representa o fim de expediente
HORARIO_COMERCIAL="06_23"

HORA_INICIO_SCRIPT=$( date +%s )

# uma hora = 3600
# duas horas = 7200
# quatro horas = 14400

SABADO="1"
DOMINGO="0"

ARQUIVO="/home/LOG_SCRIPT_ZABBIX"

##########################################################################
# RESPOSTAS PARA O ZABBIX #

# OK deve ser igual a 0 para informar que esta tudo certo
OK="0"

# N_OK deve ser igual a 1 para informar alerta amarelo
N_OK="1"

# N_OK_MAXIMO deve ser igual a 2 para informar alerta vermelho
N_OK_MAXIMO="2"

############- FUNCOES -#######################################################


verifica_chamadas(){
# Esta funcao serve para executar o comando no servidor
# alvo e colher o resultado para tomada de acoes.


QUANTIDADE=$( sudo /usr/sbin/comunix -rx "core show channels" | grep Dial | wc -l 2>/dev/null )

#QUANTIDADE="0"

#RESPOSTA="0"

# resposta serve para garantir que o comando rodou com sucesso.
RESPOSTA=$( echo $? )

valida_resposta

}

valida_resposta(){
# valida resposta ira verificar se
# o comando executou com sucesso e iniciar
# as condicionais.

        if [ "$RESPOSTA" -ne 0 ]
        then
                # aqui ja indica problema
                # pois o comando nao rodou
                # com sucesso
                echo "$N_OK"

        else
                # aqui o comando rodou sem problemas
                # entao e verificado se ha chamadas.
                valida_quantidade

                fi

        }


valida_quantidade(){
# esta funcao ira quantificar o numero de chamadas
# caso seja igual a zero ele registra no zabbix 1 ou 0 caso
# esteja certo.

        if [ "$QUANTIDADE" -ne 0 ]
then
        # aqui ele armazena o log
        # para registrar que nao houveram falhas
        # nos ultimos testes.
        echo "$OK" > "$ARQUIVO"
        echo "$OK"

else
        verifica_tempo

        fi



}

verifica_dia(){

        DIA_ATUAL=$( date +%w )
        if [ "$DIA_ATUAL" -eq "$SABADO" ] || [ "$DIA_ATUAL" -eq "$DOMINGO" ]

        then

################## se for fim de semana

# 2 horas fora = amarelo
# 4 horas = vermelho
                TEMPO_MEDIO_FORA="7200"
                TEMPO_MAXIMO_FORA="14400"

                verifica_horario
        else

################## se for semana

# 30 minutos fora = amarelo
# 1 hora fora = vermelho

                TEMPO_MEDIO_FORA="1800"
                TEMPO_MAXIMO_FORA="3600"

                verifica_horario

                fi
}



verifica_horario(){
#esta funcao verifica o horario comercial
# se estiver no horario, ele segue fluxo
# caso contrario, ele imprime n_verificar e sai

        HORA_ATUAL=$( date +%H )
        HORA_INICIAL=$( echo "$HORARIO_COMERCIAL" | awk -F "_" {'print $1'})
        HORA_FINAL=$( echo "$HORARIO_COMERCIAL" | awk -F "_" {'print $2'} )

        if [ "$HORA_ATUAL" -ge "$HORA_INICIAL" ] && [ "$HORA_ATUAL" -lt "$HORA_FINAL" ]
        then

         verifica_chamadas

        else
                echo "$OK"
               echo "$OK" > "$ARQUIVO"
                exit 0

          fi

}


verifica_tempo(){

        # Neste trecho foi identificado que nao
        # ha chamadas em curso, entao e verificado
        # ha quanto tempo esta sem chamadsa e
        # caso nao haja registros, sera feito.

        # este trecho vai capturar o arquivo
        # com o ultimo registro que ficou fora

        ULTIMA_HORA_FORA=$( cat "$ARQUIVO" )

        if [ "$ULTIMA_HORA_FORA" -ne 0 ]

        then
                # se as chamadas ja estao fora ha tempos, o calculo e feito
                TEMPO_CALCULADO=$( expr "$HORA_INICIO_SCRIPT" - "$ULTIMA_HORA_FORA" )
                # o tempo_calculado pode ser igual a 15 segundos, por exemplo
                verifica_tempo_maximo
        else
                # se as chamadas falharam agora, a contagem e iniciada.
                # e dada uma resposta de ok ja que nao houve extrapolo
        echo "$HORA_INICIO_SCRIPT"  > "$ARQUIVO"
        echo "$OK"

        fi



}

verifica_tempo_maximo(){
# esta funcao ira validar
# se as chamadas estao fora ha mais tempo
# que o tempo estipulado.

        if [ "$TEMPO_CALCULADO" -gt "$TEMPO_MAXIMO_FORA" ]

        then
                echo "$N_OK_MAXIMO"

        elif
                [ "$TEMPO_CALCULADO" -gt "$TEMPO_MEDIO_FORA" ]

        then
                echo "$N_OK"

        else
                #neste trecho a resposta e ok porque
                # nao estourou o prazo estipulado, porem
                # nao foram identificadas chamadas
                echo "$OK"

        fi

}






########### - CHAMADA DE FUNCOES - #############################################
verifica_dia
#verifica_horario
#verifica_chamadas
