#!/bin/bash
#
#
# Desenvolvido por: DevChimpa
# Data de Criação: 03/12/2024

# Contato:
# https://www.linkedin.com/in/rodrigo-pinheiro-214663206/
# https://github.com/devchimpa/
#
#######################################################################
#
#######################-DESCRICAO DO PROGRAMA-###########################
#
# Esse script serve como controlador de backup, ele quem orquestra
# o fluxo de backups realizados pelo ansible, passando os parametros
# de hosts, solucoes e destino.
# Entenda mais sobre o fluxo em: /etc/ansible/playbooks/backup_rsync_reverso.yml
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



############## Variaveis de configuracoes: ###############################

# essas variaveis servem para alterar o comportamento do script:
# Variavel do caminho parcial para envio dos arquivos:
destino_backup="/home/bkpClientes"

HORARIO_INICIO=00

HORARIO_FINAL=19

############### Variáveis Estruturais: #

# Essas sao variaveis estaticas e nao devem ser mexidas a menos que a
# estrutura do script seja modificada.

# Variaveis de controle de fluxo, essas variavies auxiliam o script a entender
# em que ponto do backup ele esta para poder prosseguir de onde parou:
controle_de_clientes="/home/extend/scripts/maestro_bkp/controle_de_fluxo/controle"
arquivo_clientes="/home/extend/scripts/maestro_bkp/controle_de_fluxo/lista_de_clientes"
arquivo_solucoes="/home/extend/scripts/maestro_bkp/controle_de_fluxo/lista_de_solucoes"
LOG_FINAL="/home/extend/scripts/maestro_bkp/controle_de_fluxo/horario_finalizado"

# Obter o número total de clientes e soluções
total_clientes=$(wc -l < "$arquivo_clientes")
max_solucao=$(wc -l < "$arquivo_solucoes")

# Leitura do estado atual do controle
codigo_cliente=$(awk -F ":" 'NR==1 {print $1}' "$controle_de_clientes")
codigo_solucao=$(awk -F ":" 'NR==1 {print $2}' "$controle_de_clientes")

##################################################################################

# Funcao para definir o alvo do backup e as variaveis necessarias
# para o ansible executar o backup.

define_alvo() {
    CLIENTE=$(awk -F ":" -v id="$codigo_cliente" '$1 == id {print $2}' "$arquivo_clientes")
    SOLUCAO=$(awk -F ":" -v id="$codigo_solucao" '$1 == id {print $2}' "$arquivo_solucoes")

    if [[ -z "$CLIENTE" || -z "$SOLUCAO" ]]; then
        desenha_macaco "Erro: Cliente ou solução não encontrado!"

        exit 1
    fi

    ALVO="${CLIENTE}_${SOLUCAO}"
    ARQUIVO_YML="/etc/ansible/inventories/"$CLIENTE"/"$ALVO".yml"

   if [[ ! -f "$ARQUIVO_YML" ]] ; then
        valida_controle
   else

        SENHA=$( cat "$ARQUIVO_YML" | grep pass |awk -F ":" {'print $2'} | tr -d " " )
        USUARIO=$( cat "$ARQUIVO_YML" | grep user |awk -F ":" {'print $2'} | tr -d " " )

  fi
}

############################################################################

realizar_backup(){
# Esta funcao chama o ansible para realizar os backups de acordo
# com os parametros recebidos:

#sleep 2
echo " $ALVO "
 /usr/bin/ansible-playbook -i /etc/ansible/inventories/"$CLIENTE"/"$ALVO".yml \
 /etc/ansible/playbooks/backup_rsync_reverso-remote_user.yml \
  --extra-vars "target_host=$ALVO diretorio_destino=$destino_backup/$CLIENTE/$SOLUCAO senha=$SENHA remote_user=$USUARIO"

}


##############################################################################

valida_controle() {
# Função para validar e atualizar o controle
# essa variavel serve para executar sempre que o script realizar o backup.

        if [ "$codigo_solucao" -lt "$max_solucao" ]; then
        codigo_solucao=$((codigo_solucao + 1))
    else
        if [ "$codigo_cliente" -lt "$total_clientes" ]; then
            codigo_cliente=$((codigo_cliente + 1))
        else
            codigo_cliente=1  # Reseta o cliente
        fi
        codigo_solucao=1  # Reseta a solução
    fi

    # Atualiza o arquivo de controle
    echo "$codigo_cliente:$codigo_solucao" > "$controle_de_clientes"

#Depois que ele executa esse trecho, ele define quem é o próximo alvo
define_alvo
}





#######################################################################################
desenha_macaco(){
clear
echo "##################################################"
echo "           --------------------------------------"
echo "           $1                                 "
echo "         /--------------------------------------"
echo "        /
     /~\
   C(o o)D   -----
    _(^)   /    /
   /__m~\m/____/ "
echo "############################################################"
}

desenha_macaco2(){
clear
echo "##################################################"
echo "           --------------------------------------"
echo "          $1                                "
echo "         /--------------------------------------"
echo "        /
     /~\
    C oo)   -----
    _( ^)  /    /
   /__m~\m/____/ "
echo "###########################################################"
}
#######################################################################################

valida_horario(){

# esta funcao define o horario que inicia e termina o script

        if [ $(date +%H ) -lt "$HORARIO_INICIO" ]

        then
                desenha_macaco2 "Fora de horário."
                exit 0

        elif [ $(date +%H ) -gt "$HORARIO_FINAL" ]

        then
                date > "$LOG_FINAL"
                desenha_macaco "Fora de horário."
                exit 0

        else

        define_alvo
        realizar_backup
        valida_controle
        valida_horario


                fi

        }


###########################################################################################
# funcao principal, funcao que ira iniciar ou parar o script
valida_horario

###########################################################################################
