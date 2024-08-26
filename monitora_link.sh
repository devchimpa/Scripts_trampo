#!/bin/bash
#
##############################################################################
# Criado por: Rodrigo Pinheiro                                               #
# Comunix Tecnologia                                                         #
# Data: 23/08/2024                                                           #
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
#       O OBJETIVO DESSE SCRIPT E MONITORAR OS LINKS DE VOZ E REGISTRAR    #
#       UM DIGITO PARA INDICAR AO ZABBIX SE O ESTA UP OU DOW               #
#                                                                          #
#       RESPOSTAS:                                                         #
#       1 = LAGGED                                                         #
#       2 = ERRO NA CAPTURA                                                #
#       0 = OK                                                             #
############################################################################

# NESTA VARIAVEL E REGISTRADO O LINK QUE
# SERA MONITORADO E CAPTURADO PELO GREP
LINK_MONITORADO="algarip"

###########################################################################

### DEPENDENCIA: ESTE SCRIPT DEPENDE O DO PACOTE SUDO, PARA QUE O ZABBIX
### CONSIGA EXECUTAR OS PROGRAMAS DO COMUNIX.

### ESTE SCRIPT DEVE ESTAR EM /etc/zabbix/scripts

###########################################################################

monitora_link(){
# este trecho ira capturar o link para
# que seja feita a validacao de disponibilidade

LINK=$( sudo asterisk -rx "sip show peers" | grep "$LINK_MONITORADO" | awk {'print $5'} | uniq 2>/dev/null )

# trecho para testes...
#LINK=$( sudo asterisk -rx "sip show peers" | grep 4603 | awk {'print $5'} | uniq 2>/dev/null )

}

valida_monitoramento(){
# este trecho ira validar
# a resposta da captura em LINK
# As respostas poderao ser enviadas ao zabbix.

        case "$LINK" in

        ok|OK)
        RESPOSTA="0"
        ;;

        lagged|LAGGED)
        RESPOSTA="1"
        ;;

        *)
        RESPOSTA="2"
        ;;
        esac

echo "$RESPOSTA"

}

monitora_link
valida_monitoramento
