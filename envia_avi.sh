define_ativo_receptivo(){

for gravacao in $(ls /home/videos/calls/2025-04-01/*avi )

do

AVI=$( echo "$gravacao" | awk  -F "_" {'print $4'} )

echo $AVI | awk -F "." {'print $1 $2'}

        if [ $(echo "$AVI" | cut -c 1-2 ) -eq 99 ]

        then

                DESTINO="/home/extend/gravacoes/ativo/2025-04-01/"
        else

                DESTINO="/home/extend/gravacoes/receptivo/2025-04-01/"


        fi

        AVI_FINAL=$( echo "$AVI" | tr -d "." | tr -d "a-z" )

        cp -rpv "$gravacao" "$DESTINO""$AVI_FINAL.avi"


done
}

define_ativo_receptivo
