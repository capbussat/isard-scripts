#!/bin/bash
echo "Servidor-mysql amb Ubuntu 26"

set -euo pipefail

instala_mysql(){
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install mysql-server -y
    mysql -V
    sudo systemctl status mysql
}

demanar_confirmacio (){
    echo 
    read -n 1 -p "$1" tecla    
    if [[ $tecla == [sS] ]]; then
        echo "..."
        "$2"
    fi
}

actualitza_xarxa(){
    sudo mv /etc/netplan/99-isardvdi-conf.yaml  /etc/netplan/99-isardvdi-conf.yaml.bak
    sudo cp 99-isardvdi-conf2.yaml /etc/netplan/99-isardvdi-conf2.yaml
    netplan apply
}

xarxa(){
  echo 
  ip address show 
  ip route show
}

demanar_confirmacio "Vols canviar la xarxa? (s/n)" actualitza_xarxa
demanar_confirmacio "Vols comprovar la xarxa? (s/n)" xarxa
demanar_confirmacio "Vols instal·lar el servidor MySQL? (s/n)" instala_mysql
