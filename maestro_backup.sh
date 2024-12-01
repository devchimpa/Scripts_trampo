#!/bin/bash
#
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
#       O objetivo deste script é funcionar como um maestro que
#       orquestra os backups feitos pelo Ansible.
#       Ele serve para que os backups sigam uma ordem para nao
#       sobrecarregar a rede durante as copias.
#       Este script pode ser melhorado, sinta-se a vontade para
#       modificar e melhorar as funcionalidades dele e dos playbooks.
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

lista_de_clientes="/home/extend/scripts/maestro_bkp/lista_de_clientes"

CODIGO="/home/extend/scripts/maestro_bkp/codigo_cliente"

CODIGO_CLIENTE=$( cat /home/extend/scripts/maestro_bkp/codigo_cliente )

HORARIO_INICIO=00

HORARIO_FINAL=23

#########################################################################


#target_host=$( cat "$lista_de_clientes" | grep "$CODIGO_CLIENTE" | awk -F ":" {'print $2'} )


valida_horario(){

# esta funcao define o horario que inicia e termina o script

        if [ $(date +%H ) -lt "$HORARIO_INICIO" ]

        then
                echo "Fora de horário."
                exit 0

        elif [ $(date +%H ) -gt "$HORARIO_FINAL" ]

        then

                echo "Fora de horário."
        date >> /home/extend/scripts/maestro_bkp/horario_finalizado
                exit 0

        else
                # chamada de funcao para verificar em que ponto da fila o backup esta
                valida_codigo_cliente

                fi

        }



valida_codigo_cliente(){

# Este trecho ira pegar na fila o proximo
# cliente a ser feito o backup.

QUANTIDADE=$( cat "$lista_de_clientes" | wc -l )

# primeiro ele verifica se a lista chegou ao fim
# caso tenha chegado, ele ira para o primeiro da fila
if [ "$CODIGO_CLIENTE" -gt "$QUANTIDADE" ]
        then
                CODIGO_CLIENTE=1
                echo "$CODIGO_CLIENTE" > "$CODIGO"
                exit 0
                fi
# caso nao tenha chegado, ele segue de onde parou
while [ "$CODIGO_CLIENTE" -le "$QUANTIDADE" ]

        do
        executa_playbook

        sleep 2


done

}


executa_playbook(){
# esta funcao chama o playbook para executar e enviar para o diretorio correto.

# este trecho define o cliente e para onde sera enviado

# esta variavel ira concatenar os nomes para o backup
cliente=$( cat "$lista_de_clientes" | grep "$CODIGO_CLIENTE" | awk -F ":" {'print $2'} )
#

#sub_dir=$( echo "$target_host" | awk -F "_" {'print $1'})

for sub_dir in $( cat /home/extend/scripts/maestro_bkp/lista_de_solutions )
do
        target_host="$cliente"_"$sub_dir"

/usr/bin/ansible-playbook -i /etc/ansible/inventories/"$sub_dir"/"$target_host".yml \
  /etc/ansible/playbooks/backup_diario_parametros.yml \
  --extra-vars "target_host=$target_host destino_backup=$destino_backup/$sub_dir"


#/usr/bin/ansible-playbook /etc/ansible/playbooks/backup_diario_parametros.yml \
#  --extra-vars "target_host=$target_host destino_backup=$destino_backup/$sub_dir"






        echo "$target_host"
        sleep 2

done

        PROXIMO_CLIENTE=$( expr "$CODIGO_CLIENTE" + 1 )

        echo "$PROXIMO_CLIENTE" > "$CODIGO"

        CODIGO_CLIENTE=$( cat "$CODIGO" )


        valida_horario

}





############################ CHAMADA DE FUNCOES ##################################
valida_horario  #primeira funcao do script
