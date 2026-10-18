#!/bin/bash
# usa scripts de ../common/
clear
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

set -euo pipefail

instala_mysql(){
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install mysql-server -y
    mysql -V
    sudo systemctl status mysql
}

actualitza_xarxa(){
    if [ -f "/etc/netplan/99-isardvdi-conf.yaml" ]; then 
        echo "Fent backup"
        sudo mv /etc/netplan/99-isardvdi-conf.yaml  /etc/netplan/99-isardvdi-conf.yaml.bak
        echo "Copia el nou fitxer a netplan."
        sudo cp $SCRIPT_DIR/99-isardvdi-conf2.yaml /etc/netplan/99-isardvdi-conf2.yaml
        netplan apply
    elif [ -f "/etc/netplan/99-isardvdi-conf2.yaml" ]; then 
        echo "Mantinc la configuracio de netplan."
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
