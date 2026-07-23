#!/bin/bash
# client-borg.sh
set -peu

SSH_USERNAME="isard"
SSH_REPO_ADDRESS='192.168.10.1'
SSH_REPO_PORT="22"

cat<<EOF
Usa Borg Backup per fer backups remots amb l'usuari ${SSH_USERNAME} 
en el servidor ${SSH_REPO_ADDRESS}:${SSH_REPO_PORT} en el directori ~/.backups
EOF

demana_confirmacio (){
    echo 
    read -n 1 -p "$1" tecla    
    if [[ $tecla == [sS] ]]; then
        echo "..."
        "$2"
    fi
}

ssh_keys(){
echo "Crea i copia les claus SSH"
ssh-keygen -t ed25519
ssh-copy-id isard@192.168.10.1
}

ssh_check(){
echo "Comprova l'accés"
ssh isard@192.168.10.1
echo "Crea el directori remot"
ssh isard@192.168.10.1 "mkdir -p ~/.backups" 
ssh isard@192.168.10.1 "mkdir -p -m 700 ~/.backups" 
ssh isard@192.168.10.1 "ls -la ~/.backups"
}
borg_install(){
sudo apt update -y
sudo apt install borgbackup
sudo apt autoremove
}

BORG_REPO="ssh://${SSH_USERNAME}@${SSH_REPO_ADDRESS}:${SSH_REPO_PORT}/~/.backups"

borg_check(){
    touch checkborg.txt

    if ! borg info "$BORG_REPO" &>/dev/null; then
        borg init --encryption=repokey "$BORG_REPO"
        echo "borg create $BORG_REPO::check checkborg.txt"
        borg create "$BORG_REPO::check" checkborg.txt
    fi

    echo "borg list $BORG_REPO"
    borg list "$BORG_REPO"
}


demana_confirmacio "Vols crear claus SSH? (s/n)" ssh_keys  
demana_confirmacio "Vols instal·lar Borg backup? (s/n)" borg_install  
demana_confirmacio "Vols provar les claus SSH? (s/n)" ssh_check  
demana_confirmacio  "Vols provar Borg backup (s/n)?"  borg_check  


