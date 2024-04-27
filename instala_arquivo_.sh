#!/bin/bash
# script para ser utilizado para instalar os arquivos necessários para o script de virus.

echo " Iniciando a instalação..."

sleep 2

apt-get install clamav clamav-docs clamav-daemon clamav-freshclam -y

sleep 2

echo " Anti virus instalado. Instalando arquivos complementares..."

sleep 2

apt-get install arc arj bzip2 cabextract lhasa lzop nomarch p7zip-full pax rpm tnef unrar-free unzip zip -y

sleep 2

echo " Inicializando os daemons ..."

sleep 1

systemctl restart clamav-freshclam

sleep 1

systemctl restart clamav-daemon

echo " Instalação concluída. "
