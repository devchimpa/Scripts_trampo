#!/usr/bin/bash
#
# Desenvolvido por: DevChimpa
# Data de Criação: 02/05/2024

# Contato:
# https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
# https://github.com/devchimpa/
#
#######################################################################
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################
# este script serve para monitorar as uras
# e identificar se tem alguma ura boba, se tiver
# um erro no zabbix será exibido.
#

########################################################################
#
##############-Siga o modelo abaixo caso mexa no script:-###############
#
# Modificado por:
# Data:
# Contato:
# Modificação feita:
#

###################################################################
# variaveis de controle, elas devem estar declaradas como 0 sempre.
OK=0
N_OK=0
####################################################################

# diretorio onde e registrado o log:
REGISTRO_DE_CHAMADAS="/etc/zabbix/scripts/logs_chamadas"

###################################################################
# script php de onde ele busca os valores
###################################################################


php /var/lib/asterisk/agi-bin/maxCallServer_teste.php | grep -i ura | grep -v "SET" | tr -d " " > "$REGISTRO_DE_CHAMADAS"


#################################################################
sleep 0.5


################################################################
# para cada resposta colhida no log, ele ira
# verificar se os valores estao vazios ou nao
# caso o valor esteja vazio, sera declarado no zabbix
# 0 significa que esta tudo ok
# 1 significa que houve erro

for URA in $( cat "$REGISTRO_DE_CHAMADAS" )

do

#echo "$URA"

VALOR=$( echo "$URA" | awk -F '=' {'print $2'} )

if [ -z "$VALOR" ]
then

        N_OK=1

fi

done
################################################################
# esse trecho valida se houve algum registro de ura vazio.#
# caso alguma ura esteja com o valor vazio, significa que há alguma erro em alguma
# ura....
#
if [ -z $N_OK  ]

then
        echo "$OK"


elif [ "$N_OK" -eq 1 ]

then

        echo "$N_OK"

else
        echo "$OK"
fi
##########################################################
