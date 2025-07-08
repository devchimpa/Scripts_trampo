#!/bin/bash
#
# Desenvolvido por: DevChimpa
# Data de Criação: 08/07/2024

# Contato:
# https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
# https://github.com/devchimpa/
#
#######################################################################
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################
#
# Este script serve para controlar e liberar o firewall, e tambem impedir
# que ele fique desabilitado, caso esteja down, o firewall será habilitado
# novamente.
# O script ira diferenciar humano de maquina, caso seja um
# humano, o script tera um comportamento, caso seja maquina, sera outro.
#
# Quando o script for executado por humano ele sempre ira, subir regras
# e tirar regras para acesso a internet
#
# Quando for uma maquina executando, ele nunca ira liberar acesso a internet.
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

# VARIAVEIS IMPORTANTES PARA O FUNCIONAMENTO CORRETO DO SCRIPT

VALIDADOR_HUMANO="/home/extend/scripts/libera_firewall/validador_humano"
VALIDADOR_SCRIPT="/home/extend/scripts/libera_firewall/validador_script"
CONTADOR="/home/extend/scripts/libera_firewall/contador"
MINUTOS=10
HUMANO=0

#########################################################

desenha_macaco(){
echo "##################################################"
echo "           --------------------------------------"
echo "          $1                                "
echo "         /--------------------------------------"
echo "        /
     /~\
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "#################################################"
}

########################################################################
# ESTA FUNCAO IRA IDENTIFICAR SE UM HUMANO OU MAQUINA EXECUTOU O SCRIPT

verifica_humano() {
    if [[ -z "$PS1" && -z "$SSH_TTY" && -z "$DISPLAY" ]]

    then

            HUMANO=0
    else
            HUMANO=1
    fi
# A VARIAVEL "HUMANO" IRA IDENTIFICAR O USUARIO AO LONGO DO USO
# DO SCRIPT
    echo $HUMANO > $VALIDADOR_HUMANO

}


#########################################################################
libera_relacao(){
# ESTA FUNCAO SERVE PARA LIBERAR CONEXOES INICIADAS PELO SERVIDOR
/usr/sbin/iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


}
############################################################################

recupera_firewall_padrao(){
# ESTA FUNCAO IRA RECUPERAR O FIREWALL PADRAO HABILITADO NA MAQUINA

/usr/sbin/iptables-restore < /etc/iptables/rules.v4
desenha_macaco "Firewall Up!"

}
############################################################################


verifica_firewall(){

# ESTA FUNCAO SERVE PARA VERIFICAR SE O FIREWALL ESTA UP
# CASO NAO ESTEJA, ELE INICIA TESTES DE VALIDACAO

FIREWALL_DOWN=$( /usr/sbin/iptables -n -L | grep -i drop | awk {'print $1'} )

if [ -z "$FIREWALL_DOWN" ]

then
# se o firewall estiver down, ele sobe o firewall padrao da maquina
desenha_macaco "Firewall Down!"
recupera_firewall_padrao
else
# se o firewall estiver up, ele ira validar se um humano esta operando o script
# para poder tomar acoes diferentes
desenha_macaco "Firewall Up!"
 if [ "$HUMANO" -eq 1 ]
 then
# se for um humano, ele verifica se ha regras
# de related estabelished, que permitem comunicacoes iniciadas pela maquina
# o related estabelhished ira permitir acesso a internet
         verifica_relacao

else
        # caso nao seja um humano executando o script, ele ira iniciar uma contagem, capturando
        # da variavel CONTADOR
        contagem_firewall
fi

fi


}
############################################################################
verifica_relacao(){

# esta funcao serve para verificar se a regra de permitir conexoes
# iniciadas pela maquina esta habilitada
RELACAO_UP=$( /usr/sbin/iptables -n -L | grep -i related | awk {'print $1'} )

if [ -z "$RELACAO_UP" ]

then
# caso a regra nao exista, ele libera para internet temporariamente
desenha_macaco "Liberando acesso."
libera_relacao
        echo "$MINUTOS" > "$CONTADOR"
exit 0

else
# caso a regra ja exista, como ja foi validado que um humano esta executando o script, ele
# bloqueia o acesso a internet bloqueando a regra
        desenha_macaco "Acesso encerrado, por gentileza solicitar liberacao novamente ao suporte."

        recupera_firewall_padrao
                fi

}
############################################################################
contagem_firewall(){
# apos validar que o script esta sendo executado pela maquina
# o sistema ira fazer uma contagem, quando esta contagem chegar a zero
# o firewall padrao da maquina sera recuperado.
        CONTAGEM=$( cat "$CONTADOR" )

        SUBTRACAO=$( /usr/bin/expr "$CONTAGEM" - 1 )

        CONTAGEM="$SUBTRACAO"

        echo "$SUBTRACAO" > "$CONTADOR"

        if [ "$CONTAGEM" -le 0 ]
        then
                recupera_firewall_padrao

                fi

}

############################################################################
# campo destinado a chamada de funcoes
############################################################################
verifica_humano
verifica_firewall
#libera_relacao
#verifica_relacao
#verifica_firewall
