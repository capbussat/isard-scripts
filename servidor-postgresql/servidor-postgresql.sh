#!/bin/bash
set -euo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADDR="192.168.37.71/24"

clear
echo "Fitxer d'instal·lació:"
echo "***";
instala_postgresql(){
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install postgresql postgresql-contrib -y
    sudo systemctl enable --now postgresql
    sudo systemctl status postgresql
    echo "Instal·lació completa"
    psql --version
    echo "***";
}

# usa script ../common/menu.sh
source "$SCRIPT_DIR/../common/menu.sh"

declare -a MENU_ITEMS=(
    "instala_postgresql:Vols instal·lar PostgreSQL?"
    "surt:Vols sortir?"
)

mostra_menu
read -ra opcio
executa_seleccio "${opcio[@]}"
echo
echo "Executat sense errors."


