#!/bin/bash
#Ferran Sousa Lorente

if (( $EUID != 0 ))
then
	echo "Aquest script ha de ser executat com a root"
	exit 1
fi

clear

wget http://www.collados.org/asix2/m06/uf2/pr2/usuaris.ods
libreoffice --headless --convert-to csv usuaris.ods

filename="usuaris.csv"
lines=$(cat $filename)
nident=3001

for line in $lines
do
    usuari=$(echo "$line" | cut -d ',' -f 2)
    echo "Creant usuari $usuari"
	useradd $usuari -u $nident -g users -d /home/$usuari -m -s /bin/bash -p $(mkpasswd clotfje)
	nident=$((nident + 1))
done
echo "Usuaris creats amb exit"
exit 0
