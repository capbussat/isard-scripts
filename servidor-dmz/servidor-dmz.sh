#!/bin/bash

set -eup

cat << EOF
Servidor DMZ (Debian Server 13)
Aquest servidor estarà connectat al Servidor-router dhcp.
Hauria de tenir una connexio enp1s0 Default
La connexió enp2s0 serà Wireguard-VPN.
La connexió enp3s0 serà estàtica. L'adreça de xarxa serà 192.168.12.0/24 en la xarxa Personal2.
És important que la xarxa sigui la Personal2 diferent de la Personal1 on hi ha el servidor dhcp.
EOF

demanar_confirmacio (){
    echo 
    read -n 1 -p "$1" tecla    
    if [[ $tecla == [sS] ]]; then
        echo "..."
        "$2"
    fi
}

xarxa(){
    sudo ip address add 192.168.12.2/24 dev enp3s0
    sudo ip route add 192.168.12.0/24 via 192.168.12.1
    ip -c address show
}

nginx(){
    echo "Actualitza i instal·la Nginx"
    sudo apt update -y && sudo apt upgrade
    sudo apt install nginx
    sudo apt autoremove
    echo "Comprova  nginx"
    sudo systemctl status nginx
}


demanar_confirmacio  "Vols configurar la xarxa? (s/n)" xarxa
demanar_confirmacio  "Vols instal·lar Nginx? (s/n)" nginx


echo "Comprova el gateway"
ping -c 4 192.168.12.1
echo "Comprova l'accés a internet"
ping -c 4 1.1.1.1
