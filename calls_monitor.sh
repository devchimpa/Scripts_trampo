#!/bin/bash
#
##############################################################################
# Criado por: Rodrigo Pinheiro                                               #
# Comunix Tecnologia                                                         #
# Data: 01/08/2024                                                           #
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
#       O objetivo do programa é acompanhar a quantidade de bilhetes
#       na main e caso haja um volume alto, reiniciar o processo...        #
#                                                                          #
#                                                                          #
############################################################################



# VARIÁVEIS DE CONFIGURAÇÃO

# Diretório base onde as pastas dos dias estão localizadas
DIRETORIO="/home/extend/calls/main"

# AQUI DEVE SER INSERIDO O VALOR CONSIDERADO ALTO
# PARA A QUANTIDADE DE BILHETES

VOLUME=50

######################## FUNÇÕES #######################################


mata_e_sobe_trata(){


PID_DO_TRATA=$( ps aux | grep  /home/extend/./trata_estatistica | grep -v grep | awk {'print $2'} )
kill -9 $PID_DO_TRATA
/home/extend/trata_estatistica &

}

# FUNÇÃO PARA VERIFICAR OS BILHETES

check_bilhetes() {
for diretorio_dia in "$DIRETORIO"/2024-*/
do
        if [ -d "$diretorio_dia" ]
         then
                CONTAGEM=$(ls "$diretorio_dia" | wc -l)

                if [ "$CONTAGEM" -gt "$VOLUME" ]
         then
       echo "ALERTA: O diretorio $diretorio_dia contem: $CONTAGEM bilhetes."
       # Neste ponto será reiniciado processo do trata para reprocessar os bilhetes novamente.
           mata_e_sobe_trata
      fi
    fi
  done
}


# FUNÇÃO INFINITA PARA SEMPRE VERIFICAR OS BILHETES
roda_script(){

while true

 do

  check_bilhetes

  sleep 1

done
}

##############################################################################################
                               #CHAMADA DE FUNÇÕES#
##############################################################################################

# O SCRIPT PRINCIPAL É O roda_script ELE QUEM DEVE SER DESCOMENTADO.
# AS OUTRAS FUNÇÕES DEVEM SER HABILITADAS APENAS PARA FINS DE TESTES.

#mata_e_sobe_trata

#check_bilhetes

roda_script
