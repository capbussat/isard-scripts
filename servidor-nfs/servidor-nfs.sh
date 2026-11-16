#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADDR="192.168.1.1/24"
NET="192.168.1.0/24"

clear
echo "Fitxer d'instal·lació:"
echo "***";
instala_nfs(){
  sudo apt update -y && sudo apt upgrade -y
  sudo apt install nfs-kernel-server
  echo "Instal·lació completa"
  sudo systemctl restart nfs-kernel-server
  sudo systemctl status nfs-kernel-server
  echo "***";
}

crea_fitxer_exports(){
  sudo mkdir -p /srv/shared
  echo "Creat el directori /srv/shared"
  sudo chown -R nobody:nogroup /srv/shared
  sudo find /srv/shared -type d -exec chmod 755 {} +
  sudo find /srv/shared -type f -exec chmod 644 {} +
  echo "Permisos aplicats."
  if [ -f /etc/exports ]; then
    echo "Ja existeix /etc/networks. Vols continuar i esborrar-lo o sortir amb cltr+c)?"
    read -n1;
    sudo rm /etc/exports
    echo "Esborrat /etc/exports ..."
  fi
  sudo touch /etc/exports
  echo "/srv/shared 192.168.1.0/24(ro,sync,no_subtree_check)" | sudo tee -a /etc/exports   
  sudo exportfs -ra
  echo "Permís de lectura per a la xarxa 192.168.1.0/24."
}

install_autofs(){
  sudo apt update -y &&  sudo apt install autofs nfs-common
  sudo touch /etc/auto.master
  echo "en desenvolupament" | sudo tee -a /etc/auto.master
  echo "Creat /etc/auto.master"
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
  "crea_fitxer_exports:Configura el fitxer /etc/exports amb /srv/shared en lectura"
  "actualitza_xarxa:Vols actualitzar la xarxa?"
  "comprova_xarxa:Vols comprovar la xarxa?"
  "surt:Vols sortir?"
)

mostra_menu
read -ra opcio
executa_seleccio "${opcio[@]}"
echo
echo "Executat sense errors."
