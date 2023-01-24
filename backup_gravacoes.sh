#       LAÇO FOR PARA PEGAR AS GRAVACOES DENTRO DE 3 DIRETÓRIOS CONSECUTIVOS.
#

#############################################################################

CAMINHO_ORIGEM="/home/backups/gravacoes/"
DESTINO_ENVIO="/home/backups/gravacoes/"


##############################################################################
# criado por: DevChimpa                                                      #
# Data: 24/01/2023                                                           #
# Contato: chimpadeveloper@gmail.com                                         #
#         https://github.com/devchimpa/                                      #
#                                                                            #
##############################################################################
#
# Caminho = Disc -> Ura ->  Datas -> Gravacoes
#

cd "$CAMINHO_ORIGEM"


separa_gravacoes (){
        GRAVACAO_RECEBIDA=$1



}



for disc in *
  do
        echo $disc
        cd $disc
        for ura in *
        do
                echo $ura
                cd $ura
                for i in *
                do
                        GRAVACAO=$(echo $i )
                        echo $GRAVACAO
                        sleep 2
                done
        cd ..
        done
        cd ..
done
