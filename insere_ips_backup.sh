#!/bin/bash
#
# Desenvolvido por: DevChimpa
# Data de Criação: 27/09/2024

# Contato:
# https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
# https://github.com/devchimpa/
#
#######################################################################
#
#######################-DESCRIÇÃO DO PROGRAMA-###########################

#O objetivo desse script é agilizar a insercao de ips nos arquivos
#de backup e de maneira ordenada, principalmente se houverem muitos
#a serem cadastrados.

#o script deve ser executado da seguinte maneira:

#./verifica CLIENTE



########################################################################

verifica(){

        ARQUIVO="$1"
        ULTIMO=$( tail -n -1 "$ARQUIVO" | awk -F ":" {'print $1'} | tr -d a-z )
        if [ -z "$ULTIMO" ]
                then
                                echo "A ultima linha do $ARQUIVO não pode estar em branco."

                                exit 0
                        fi
SERVIDORES="
192.168.9.117
192.168.9.116
192.168.9.118
10.190.0.20
10.190.0.29
10.190.0.16
10.190.0.14
10.190.0.22
10.190.0.12
10.190.0.21
10.190.0.19
10.190.0.17
10.190.0.15
10.190.0.23
10.190.0.13
192.168.10.118
10.190.0.18
192.168.10.119

"


for LINHA in ${SERVIDORES[*]}
        do
                EXISTE=$( grep "$LINHA" "$ARQUIVO" )
                if [ -z "$EXISTE" ]

                then
                        SOMA=$( expr "$ULTIMO" + 1 )
                        echo "ip""$SOMA":"$LINHA" >> "$ARQUIVO"
                        echo "Adicionado:"
                        echo "ip""$SOMA":"$LINHA"
                        ULTIMO="$SOMA"

                        fi
  done

}
verifica "$1"

