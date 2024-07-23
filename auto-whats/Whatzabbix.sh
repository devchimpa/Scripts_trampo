#!/bin/bash
#
#
# Desenvolvido por: DevChimpa
# Data de Criação: 23/07/2024
#
# Contato:
# https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
# https://github.com/devchimpa/
#
#######################################################################
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################
#
# Este script utiliza uma api configurada na nuvem da Comunix
# para enviar falhas do zabbix para o celular configurado via whatsapp
#
# Este scritp  necessita das seguintes variáveis em ordem no Zabbix para funcionar.
# {EVENT.TIME} {EVENT.DATE} {HOST.NAME} {EVENT.SEVERITY}
#
# Estas variáveis serão enviadas para o script por meio do comando curl
# utilizando o método POST e a mensagem whatsapp será enviada pela API
#
#########################################################################

# ESTE É O NUMERO DE TELEFONE PARA ONDE A MENSAGEM SERÁ ENVIADA
# O NUMERO DEVE SER CONFIGURADO DA SEGUINTE MANEIRA: 61999999999

NUMERO_TELEFONE="61999999999"


# MENSAGEM É A VARIÁVEL QUE RECEBE DO ZABBIX AS INFORMAÇÕES
# PARA SEREM TRATADAS E PODER PASSAR DA FORMA CERTA PARA A API

MENSAGEM="$1"

# NESTE PONTO A VARIÁVEL MENSAGEM É TRATADA

trata_mensagem(){

EVENT_TIME=$( echo $MENSAGEM | tr "\n " " " | awk {'print $1'} )
EVENT_DATE=$( echo $MENSAGEM | tr "\n " " " | awk {'print $2'} )
HOST_NAME=$( echo $MENSAGEM | tr "\n " " " | awk {'print $6'} )
EVENT_SEVERITY=$( echo $MENSAGEM | tr "\n " " " | awk {'print $13'} )

}


######################################################################

envia_mensagem(){

curl --location "https://whatsapp.LINK" \
--header "Content-Type: application/json" \
--data-raw "{
    \"app\":\"NOMEEMPRESA\",
    \"appid\":\"$APPID\",
    \"importer_email\":\"@email.com\",
    \"importer\":\"999999\",
    \"customer\":\"CLIENTE_ZABIX\",
    \"telefone\":\"$NUMERO_TELEFONE\",
    \"token\":\"TOKEN DA API\",
    \"template\":\"IDENTIFICAÇÃO DA TEMPLATE\",
    \"template_param\":[\"$EVENT_TIME\",\"$EVENT_DATE\",\"$HOST_NAME\",\"$EVENT_SEVERITY\"]
}"

}



################ chamada de funções #####################################

trata_mensagem

sleep 0.5

envia_mensagem





################ FIM DO SCRIPT #####################################

# RASCUNHO PARA O LEMBRAR COMO FORAM FEITOS OS CORTES
# CASO NECESSITE DE ALTEAÇÕES FUTURAMENTE

echo "$EVENT_TIME event_time" >> texto_final
echo "$EVENT_DATE event_date" >> texto_final
echo "$HOST_NAME event_name" >> texto_final
echo "$EVENT_SEVERITY event_severity" >> texto_final

