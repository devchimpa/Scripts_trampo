#!/bin/bash
---		
# Desenvolvido por: DevChimpa
# Data de Criação: 22/11/2024

# Contato:
# https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
# https://github.com/devchimpa/
#
#######################################################################
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################
#
#	O objetivo deste script é funcionar como um maestro que
#	orquestra os backups feitos pelo Ansible.
#	Ele serve para que os backups sigam uma ordem para nao
#	sobrecarregar a rede durante as copias.
#	Este script pode ser melhorado, sinta-se a vontade para
#	modificar e melhorar as funcionalidades dele e dos playbooks.
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
##########################################################################


###################### VARIAVEIS DE CONFIGURACAO #########################

# esta variavel configura o destino para onde
# o backup sera enviado

destino_backup="/home/bkp_ansi/"


controle_de_clientes="/home/extend/scripts/maestro_bkp/controle"


CODIGO="/home/extend/scripts/maestro_bkp/codigo_cliente"


CODIGO_CLIENTE=$( cat /home/extend/scripts/maestro_bkp/codigo_cliente )


HORARIO_INICIO=00


HORARIO_FINAL=23


QUANTIDADE=$( cat "$controle_de_clientes" | wc -l )



#ansible-playbook -i /etc/ansible/inventories/teste/teste_ura.yml backup_rsync_sshpass.yml \
#  --extra-vars "target_host="$ALVO" diretorio_destino=/home/bkp_ansi/"$CLIENTE"/ senha="$SENHA"



CLIENTE_ATUAL=$( cat $controle_de_clientes)

SENHA=$( cat /etc/ansible/inventories/teste/teste_ura.yml  | grep pass | awk  -F ":" {'print $2'} | tr -d " " )


###################
controle_de_fluxo(){

SOLUCAO=$( cat $controle_de_clientes | awk -F ":" {'print $3'} )
CLIENTE=$( cat $controle_de_clientes | awk -F ":" {'print $2'} )
CODIGO=$( cat $controle_de_clientes | awk -F ":" {'print $1'} )

ALVO="$CLIENTE"_"$SOLUCAO"

echo "$CODIGO:$CLIENTE:$SOLUCAO" > controle



#ansible-playbook -i /etc/ansible/inventories/teste/teste_ura.yml \
#  /etc/ansible/playbooks/backup_rsync_sshpass_parametros.yml \
#  --extra-vars "target_host=$ALVO diretorio_destino=/home/bkp_ansi/$CLIENTE/$SOLUCAO senha=$SENHA"



ENDERECOS=$( cat /etc/ansible/inventories/"$CLIENTE"/"$CLIENTE"_"$SOLUCAO".yml | grep [0-9] | grep -v pass | tr -d : | tr -d " " )

}


#####################
valida_codigo_cliente(){


if [ "$CODIGO_CLIENTE" -gt "$QUANTIDADE" ]
        then
                CODIGO_CLIENTE=1
                echo "$CODIGO_CLIENTE" > "$CODIGO"
                exit 0
                fi
# caso nao tenha chegado, ele segue de onde parou
while [ "$CODIGO_CLIENTE" -le "$QUANTIDADE" ]

        do

echo "$CLIENTE"


done
}



####################################################################################################
controle_de_fluxo
#valida_codigo_cliente
#
