#!/bin/bash
#Ferran Sousa Lorente

if (( $EUID != 0 ))
then
	echo "Aquest script ha de ser executat com a root"
	exit 1
fi

DATA=$(date +20%y%m%d%H%M)

clear

if [[ -e /etc/dhcp/dhcpd.conf ]]
then
	cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.$DATA
	rm /etc/dhcp/dhcpd.conf
fi

echo -n "Especifica el nom del domini: "
read nomdomini
echo -n "Especifica l'adreça IP del servidor DNS (només 1): "
read ipdns
echo -n "Especifica l'adreça IP del router per defecte: "
read iprouter
echo -n "Especifica el temps de leasing per defecte: "
read defleasing
echo -n "Especifica el temps de leasing màxim: "
read maxleasing
echo -n "Especifica l'adreça IP de la subxarxa a la qual s'assignaran IPs: "
read ipsubxarxa
echo -n "Especifica la màscara de la subxarxa: "
read masksubxarxa
echo -n "Especifica la primera IP del marge d'adreces: "
read primeraip
echo -n "Especifica la darrera IP del marge d'adreces: "
read ultimaip

echo "subnet $ipsubxarxa netmask $masksubxarxa {" >> /etc/dhcp/dhcpd.conf
echo "" >> /etc/dhcp/dhcpd.conf
echo "  range $primeraip $ultimaip;" >> /etc/dhcp/dhcpd.conf
echo "  option routers $iprouter;" >> /etc/dhcp/dhcpd.conf
echo "  option domain-name-servers $ipdns;" >> /etc/dhcp/dhcpd.conf
echo "  option domain-name \"$nomdomini\";" >> /etc/dhcp/dhcpd.conf
echo "  default-lease-time $defleasing;" >> /etc/dhcp/dhcpd.conf
echo "  max-lease-time $maxleasing;" >> /etc/dhcp/dhcpd.conf
echo "  authoritative;" >> /etc/dhcp/dhcpd.conf
echo "  ddns-update-style none;" >> /etc/dhcp/dhcpd.conf
echo "}" >> /etc/dhcp/dhcpd.conf

echo "Fitxer creat amb èxit"
systemctl restart isc-dhcp-server

exit 0
