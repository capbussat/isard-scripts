#!/bin/bash
# client-borg.sh
set -peu

export BORG_REPO=ssh://isard@192.168.10.1:22/~/.backups/

cat << EOF
Client Borg backup que copiarà per SSH al servidor dhcp.  
Instal·la borg backup.
Crea una clau per accedir al servidor dhcp per SSH.
EOF

ssh_keys(){
echo "Crea i copia les claus SSH"
ssh-keygen -t ed25519
ssh-copy-id isard@192.168.10.1
echo "Comprova l'accés"
ssh isard@192.168.10.1
echo "Crea el directori remot"
ssh isard@192.168.10.1 "mkdir -p ~/.backups" 
ssh isard@192.168.10.1 "mkdir -p -m 700 ~/.backups" 
ssh isard@192.168.10.1 "ls -la ~/.backups"
}

install(){
sudo apt update -y
sudo apt install borgbackup
sudo apt autoremove
}

check(){
touch checkborg.txt
borg create $BORG_REPO::check checkborg.txt
borg list check
}

ssh_keys
install
check
