#!/bin/bash
# client-borg.sh
# surt del script al primer error
set -euo pipefail

SSH_USERNAME="isard"
SSH_REPO_ADDRESS='192.168.10.1'
SSH_REPO_PORT="22"
BORG_REPO="ssh://${SSH_USERNAME}@${SSH_REPO_ADDRESS}:${SSH_REPO_PORT}/~/.backups"

cat<<EOF
Usa Borg Backup per fer backups remots amb l'usuari ${SSH_USERNAME} 
en el servidor ${SSH_REPO_ADDRESS}:${SSH_REPO_PORT} creant un directori remot ~/.backups
EOF

ssh_keys(){
    echo "Crea i copia les claus SSH en el remot ..."
    ssh-keygen -t ed25519
    ssh-copy-id "${SSH_USERNAME}@${SSH_REPO_ADDRESS}"
}

sssh_check(){
    echo "Comprova l'accés per ssh ..."
    ssh -o ConnectTimeout=10 "${SSH_USERNAME}@${SSH_REPO_ADDRESS}" -p "${SSH_REPO_PORT}" "echo ok"
    echo "Crea el directori remot"
    ssh -o ConnectTimeout=10 "${SSH_USERNAME}@${SSH_REPO_ADDRESS}" -p "${SSH_REPO_PORT}" "mkdir -p -m 700 ~/.backups"
    ssh -o ConnectTimeout=10 "${SSH_USERNAME}@${SSH_REPO_ADDRESS}" -p "${SSH_REPO_PORT}" "ls -la ~/.backups"
}

borg_install(){
    echo "Instal·la Borgbackup (en curt Borg) ..."
    sudo apt update -y
    sudo apt install -y borgbackup
    sudo apt autoremove -y
}

borg_check(){
    echo "Posa un fitxer local en un nou repositori a $BORG_REPO ..."
    touch checkborg.txt
    if ! borg info "$BORG_REPO" &>/dev/null; then
        borg init --encryption=repokey "$BORG_REPO"
        echo "borg create $BORG_REPO::check checkborg.txt"
        borg create "$BORG_REPO::check" checkborg.txt
     else
        echo "Ja existeix el repositori."
    fi
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/menu.sh"

declare -a MENU_ITEMS=(
    "ssh_keys:Vols crear claus SSH?"
    "borg_install:Vols instal·lar Borg backup?"
    "ssh_check:Vols provar les claus SSH?"
    "borg_check:Vols provar Borg backup?"
)

mostra_menu
read -ra opcio
executa_seleccio "${opcio[@]}"

