#!/bin/bash
#
#
#
#
# Feito por: Rodrigo Pinheiro, 10 de Novembro de 2023.
#
# --------------------------------------------------
# Modificado por:( caso mexa no script, coloque nome e data.)
# -------------------------------------------------
# Modificado por:
#
#
#
# Este script não tem dono, sinta-se à vontade para melhorá-lo...
#
#
#
#
##########################################################################################
#
#
# O objetivo deste script é buscar gravações dentro do diretório definido na função procura()
#
# O script funciona por meio de um laço for que vai fazendo a comparação para identificar
# se os arquivos localizados na varredura são os mesmos que solicitamos, caso seja
# ele irá registrar um log indicando a localização do arquivo.
#
#-----------------------------------------------------------------------------------------
################################ Boas práticas ############################################
#------------------------------------------------------------------------------------------
#
# O script está todo comentado e comentários são sempre bem vindos.
# Caso acrescente algo, comente, coloque data e assinatura para
# que todos saibam o que foi alterado, quando e por quem para caso de dúvidas.
#
# Mantenha variáveis GLOBAIS em maiúsculas
#
# Mantenha nomes minimamente claros e em português
#
#
#
#
############################################################################################
#
#                        CONFIGURAÇÕES DO SCRIPT:
#               ( utilize este campo para configurar o script)
#
#########################################################################################
#
#
#diretorio onde o script deve iniciar a busca:
DIRETORIO_DEFINIDO=/mnt2
#
#Lista que será usada pelo script para leitura, os arquivos que queremos localizar
#devem estar dentro dela
LISTA_DE_BUSCAS=/home/lista_de_procuradas
#
#arquivo onde devem ser registradas gravacoes localizadas:
ARQUIVO_DE_LOG=/home/gravacao_localizada
#



############################## INICIO DO SCRIPT #############################################


# Esta funcao serve para leitura do arquivo de gravacoes solicitadas
# caso a lista esteja zerada o script encerra.

verifica_procura(){

        arquivo_vazio=$( wc -w $LISTA_DE_BUSCAS | tr -d "a-z" | tr -d "_"  | tr -d "/" )

        if [ $arquivo_vazio -eq 0 ]
        then
        echo "Lista Finalizada."
        exit 0
fi
}


# Esta função servirá para comparar se o arquivo que ele achou é o mesmo que estamos procurando.

compara(){

  LOCALIZADO=$( echo $1 | tr "/" " " | rev | awk '{ print $1 }' | rev )

# aqui para cada linha do arquivo ele fará a comparação com o arquivo localizado.
for linha in $(cat $LISTA_DE_BUSCAS)
        do
        GRAVACAO=$linha
# se a gravacao que procuramos for igual a gravacao que ele achou, então ele ira registrar no log
  if [ "$GRAVACAO" = "$LOCALIZADO" ]

  then
        echo
        echo "$1 achou!"
        #estes echo vazios servem para criar um espaço entre as gravaçoes localizadas e deixar a visibilidade melhor
        echo
        echo $1 >> $ARQUIVO_DE_LOG

        fi

done
}




# Esta função serve para varrer os diretórios que definimos para a busca.
# Ele irá começar a procura a partir dali e irá procurar recursivamente em todos os diretórios.

procura(){

# A Função recebe como parâmetro o diretorio
  DIRETORIO_A_VARRER=$1

  for arquivo in "$DIRETORIO_A_VARRER"/*
do

  verifica_procura

# Se for um arquivo ele verifica se este é igual o que estamos procurando
  if [ -f "$arquivo" ]
  then
# este printf serve para que seja possivel visualizar a verificação
# caso nao queira visualizar, basta comentar.
 printf "Verificando arquivo: %s\r" "$arquivo"
  compara $arquivo
# se for um diretório, ele entra no diretório e continua a varredura.

elif [ -d "$arquivo" ]
then
    procura $arquivo
  fi

done

}


######################## Para ativar/desativar o script #########################################
############################ comente ou descomente.##############################################
#################################################################################################
# aqui inicia o script, neste trecho estamos chamando o script para começar a varredura
# no diretório configurado lá em cima.

procura $DIRETORIO_DEFINIDO
echo
echo " Programa finalizado..."

##############################################################################################
