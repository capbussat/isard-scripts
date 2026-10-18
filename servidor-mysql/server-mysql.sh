#!/bin/bash
# usa script ../common/
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADDR="192.168.37.2/24"

clear

instala_mysql(){
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install mysql-server -y
    mysql -V
    sudo systemctl status mysql
}

actualitza_xarxa(){
if [ -f "/etc/netplan/99-isardvdi-conf.yaml" ]; then 
    echo "Fent backup"
    sudo mv /etc/netplan/99-isardvdi-conf.yaml /etc/netplan/99-isardvdi-conf.yaml.bak
fi

if [ ! -f "/etc/netplan/99-isardvdi-conf2.yaml" ]; then 
    echo "Crea el nou fitxer a netplan."
    cat > "/etc/netplan/99-isardvdi-conf2.yaml" <<EOF
network:
  version: 2
  ethernets:
    enp1s0: 
      dhcp4: true
      dhcp6: false
    enp2s0:
      dhcp4: false
      dhcp6: false
      addresses:
        - ${ADDR}
EOF
    chmod 600 /etc/netplan/99-isardvdi-conf2.yaml
    netplan apply
else
    echo "No cal actualitzar la configuració de netplan"
fi
}

xarxa(){
  echo 
  ip address show 
  ip route show
}


source "$SCRIPT_DIR/../common/menu.sh"

declare -a MENU_ITEMS=(
    "actualitza_xarxa:Vols canviar la xarxa?"
    "xarxa:Vols comprovar la xarxa?"
    "instala_mysql:Vols instal·lar el servidor MySQL?"
    "surt:Vols sortir?"
)

mostra_menu
read -ra opcio
executa_seleccio "${opcio[@]}"
