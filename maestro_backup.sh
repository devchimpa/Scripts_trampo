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
#       modificar e melhorar as funcionalidades.
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

destino_backup=/home/bkp_ansi/

lista_de_clientes=/home/extend/scripts/lista_de_clientes

CODIGO="/home/extend/scripts/codigo_cliente"

CODIGO_CLIENTE=$( cat /home/extend/scripts/codigo_cliente )

#########################################################################


#target_host=$( cat "$lista_de_clientes" | grep "$CODIGO_CLIENTE" | awk -F ":" {'print $2'} )


define_cliente(){

# esta funcao ira selecionar um cliente da lista
# para fazer o backup e seguir selecionando em ordem

        QUANTIDADE=$( cat "$lista_de_clientes" | wc -l )

        # se QUANTIDADE for igual a quantidade da lista,
        # ele inicia o backup, mas zera a lista.
        if [ "$QUANTIDADE" -eq "$CODIGO_CLIENTE" ]
                then

                target_host=$( cat "$lista_de_clientes" | grep "$CODIGO_CLIENTE" | awk -F ":" {'print $2'} )

                echo 0 > "$CODIGO"

                inicia_backup


        # se QUANTIDADE for maior que quantidade da lista,
        # ele inicia o backup, mas zera a lista.
        elif [ "$CODIGO_CLIENTE" -gt "$QUANTIDADE" ]

                then

                CODIGO_CLIENTE=0

                target_host=$( cat "$lista_de_clientes" | grep "$CODIGO_CLIENTE" | awk -F ":" {'print $2'} )

                inicia_backup

        else


                target_host=$( cat "$lista_de_clientes" | grep "$CODIGO_CLIENTE" | awk -F ":" {'print $2'} )

                inicia_backup


                fi


}

inicia_backup(){

        # aqui ele ira executar o playbook e somar o codigo do cliente.
        echo " Realizando backup de: $target_host "
        PROXIMO_CLIENTE=$( expr "$CODIGO_CLIENTE" + 1 )
        echo "$PROXIMO_CLIENTE" > "$CODIGO"
}





executa_playbook(){
# esta funcao chama o playbook para executar e enviar para o diretorio correto.

/usr/bin/ansible-playbook /etc/ansible/playbooks/backup_diario_parametros.yml \
  --extra-vars "target_host=$target_host destino_backup=$destino_backup"

}

############################ CHAMADA DE FUNCOES ##################################
define_cliente  #primeira funcao do script
##################
inicia_backup

#executa_playbook
