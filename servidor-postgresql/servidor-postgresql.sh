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

crea_bd_alumnes(){
if [ -f "alumnes.csv"]; then
    chown isard:isard alumnes.csv 
    cp alumnes.csv /tmp/alumnes.csv
    psql -u postgres -f alumnes.sql
fi
}

surt(){
echo "Adéu";
}

# usa script ../common/menu.sh
source "$SCRIPT_DIR/../common/menu.sh"

declare -a MENU_ITEMS=(
    "instala_postgresql:Vols instal·lar PostgreSQL?"
    "crea_bd_alumnes:Vols crear la base de dades alumnes i la seva taula alumnes?"
    "surt:Vols sortir?"
)

mostra_menu
read -ra opcio
executa_seleccio "${opcio[@]}"
echo
echo "Executat sense errors."


