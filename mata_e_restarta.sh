#!/bin/bash

#Quem fez: Heinrick Camargo & DevChimpa

#Quando: 07/06/2023

#Contato: https://github.com/devchimpa ; https://github.com/HeinrickCamargos

#O que faz: Este script mata e reinicializa a tela de visão anvisa.
# Por exemplo: TICKET#20230607670015 zammad

################################################################################

# BOAS PRÁTICAS:

# VARIÁVEIS DEVEM SER DECLARADAS COM LETRAS MAIÚSCULAS

# VARIÁVEIS DEVEM TER NOMES CLAROS COMO "PID_ANVISA"

# FUNÇÕES DEVEM SER DECLARADAS COM LETRAS minúsculas

################################################################################                                                                                                                                                             #

# CASO MEXA NESSE SCRIPT OU TENHA ALGUMA MELHORIA, INFORMAR NESTE CAMPO ABAIXO:

# NOME:

# DATA DE MODIFICAÇÃO:

# O QUE FOI MODIFICADO:


###############################################################################


PID_ANVISA=$( netstat -nlp | grep 5505 | tr "/" " " | awk {'print $7'} )

echo "########################################################"

echo " O processo de pid: $PID_ANVISA será encerrado..."

echo "########################################################"

kill -9 $PID_ANVISA

echo "########################################################"

echo " Um momento enquanto reinicio os processos..."

echo "########################################################"

sleep 1

/etc/init.d/restartd restart $0 > /dev/null

echo "########################################################"

echo "Processos reinicializados. Buscando novo PID..."

echo "########################################################"
sleep 1

PID_NOVO=$( netstat -nlp | grep 5505 | tr "/" " " | awk {'print $7'} )

echo "########################################################"

echo " O novo número de PID é: $PID_NOVO "

echo "########################################################"

echo "Programa encerrado..."
