#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADDR="192.168.224.1"

clear
echo "Fitxer d'instal·lació:"
echo "***";
instala_nfs(){
  sudo apt update -y && sudo apt upgrade -y
  sudo install nfs-kernel-server
  echo "Instal·lació completa"
  sudo systemctl restart nfs-kernel-server
  sudo systemctl status nfs-kernel-server
  echo "***";
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

comprova_xarxa(){
  echo 
  ip address show
  echo 
  ip route show
}

surt(){
echo "Adéu";
}

# usa script ../common/menu.sh
source "$SCRIPT_DIR/../common/menu.sh"

declare -a MENU_ITEMS=(
  "instala_nfs:Vols instal·lar el servidor NFS?"
  "actualitza_xarxa:Vols actualitzar la xarxa?"
  "comprova_xarxa:Vols comprovar la xarxa?"
  "surt:Vols sortir?"
)

mostra_menu
read -ra opcio
executa_seleccio "${opcio[@]}"
echo
echo "Executat sense errors."
