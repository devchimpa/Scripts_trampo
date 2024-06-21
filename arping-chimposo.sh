# Desenvolvido por: DevChimpa
# Data de Criação: 29/05/2024

# Contato:
# https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
# https://github.com/devchimpa/
#
#######################################################################
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################

# Este script verifica se o servidor Share está com o IP virtual
# caso esteja, ele irá rodar o arping, do contrário ele encerra.
# este script roda nos dois servidores Share.

########################################################################
#
##############-Siga o modelo abaixo caso mexa no script:-###############
#
# Modificado por:
# Data:
# Contato:
# Modificação feita:
#
#########################################################################



roda_arping(){


      /usr/sbin/arping -i eth0 -c2  -S 192.168.1.63 -B
      /usr/sbin/arping -i eth0 -c2 -S 192.168.1.63 192.168.0.10

}


IP_VIRTUAL="$( ip a | grep 192.168.1.63 | tr "/" " " | awk {'print $2'} )"

        if [ -x $IP_VIRTUAL ]

        then

        echo "sem ip"


        else

        roda_arping

fi
