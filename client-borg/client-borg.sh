#!/bin/bash
# client-borg.sh
set -peu

export BORG_REPO="ssh://isard@192.168.10.1:22/~/.backups/"

seguim(){
    read -n 1 -p "$1" tecla
    if [[ $tecla == [sS] ]]; then
        echo            
        echo "Sortint de l'script."
        exit 1
    else 
        echo "..."
    fi  
}

demana_confirmacio (){
    echo 
    read -n 1 -p "$1" tecla    
    if [[ $tecla == [sS] ]]; then
        echo "..."
        "$2"
    fi
}

cat << EOF
Client Borg backup que copiarà per SSH al servidor dhcp.  
Instal·la borg backup.
Crea una clau per accedir al servidor dhcp per SSH.
EOF

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
ssh isard@192.168.10.1 "borg init --encryption=repokey ~/.backups"
}

borg_install(){
sudo apt update -y
sudo apt install borgbackup
sudo apt autoremove
}

borg_check(){
touch checkborg.txt
borg create $BORG_REPO::check checkborg.txt
borg list check
}

demana_confirmacio "Vols crear claus SSH? (s/n)" ssh_keys
demana_confirmacio "Vols instal·lar Borg backup? (s/n)" borg_install
demana_confirmacio "Vols provar les claus SSH? (s/n)" ssh_check
demana_confirmacio "Vols provar Borg backup (s/n)?"  borg_check
check
