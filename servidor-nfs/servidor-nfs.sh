#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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



surt(){
echo "Adéu";
}

# usa script ../common/menu.sh
source "$SCRIPT_DIR/../common/menu.sh"

declare -a MENU_ITEMS=(
    "instala_nfs:Vols instal·lar el servidor NFS?"
    "surt:Vols sortir?"
)

mostra_menu
read -ra opcio
executa_seleccio "${opcio[@]}"
echo
echo "Executat sense errors."
