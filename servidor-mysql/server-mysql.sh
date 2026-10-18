#!/bin/bash
# usa scripts de ../common/
echo "Servidor-mysql amb Ubuntu 26"

set -euo pipefail

instala_mysql(){
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install mysql-server -y
    mysql -V
    sudo systemctl status mysql
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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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
