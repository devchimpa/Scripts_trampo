procura_lista(){ 
for i in $( cat /home/lista_de_procuradas ) 
do echo "procurando: $i " 
find /mnt2/ -iname $i done } 
