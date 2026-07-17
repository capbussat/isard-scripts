# incus.sh
# sudo chmod +x incus.sh; ./incus.sh

# si falla surt de l'script
set -eu

cat << EOF
Servidor Incus (Ubuntu 24)
Instal·lació i configuració de l'entorn de virtualització Incus (LXD) en Ubuntu 24.04 LTS
enp1s0 xarxa Default
enp2s0 Xarxa Wireguard-VPN
enp3s0 xarxa LAN Personal1
EOF

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

install(){
    echo "Instal·lant Incus (LXD)..."
    sudo hostnamectl set-hostname servidor-incus
    sudo apt update -y
    sudo apt install -y incus
    sudo apt autoremove
    sudo incus admin init --minimal
    sudo usermod -aG incus-admin $USER
    sudo newgrp incus-admin
    echo "Incus (LXD) instal·lat i configurat correctament."
    echo "Per a que els canvis de grup tinguin efecte, tanca la sessió i torna a entrar."
}

container(){
    echo "Creant un contenidor..."
    incus launch images:ubuntu/24.04 mycontainer
    incus config set mycontainer security.nesting true
    incus exec mycontainer -- bash -c "apt update && apt install -y curl"
}

delete_container(){
    echo "Eliminant el contenidor..."
    incus stop mycontainer --force
    incus delete mycontainer --force
    echo "Contenidor eliminat correctament."
}

install_zammad(){
    echo "Instal·lant eines necessàries..."
    incus exec mycontainer -- bash -c  "apt update -y && sudo apt install -y apt-transport-https gnupg"
    echo "Download and Add the Public Signing Key for Elasticsearch"
    incus exec mycontainer -- bash -c  "curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch |  gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg"
    incus exec mycontainer -- bash -c  "gpg --show-keys /usr/share/keyrings/elasticsearch-keyring.gpg"
    incus exec mycontainer -- bash -c  "chmod 644 /usr/share/keyrings/elasticsearch-keyring.gpg"
    echo "Add the Elasticsearch APT Repository"
    incus exec mycontainer -- bash -c  "echo \"deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/9.x/apt stable main\" |  /etc/apt/sources.list.d/elastic-9.x.list"
    echo "Install Elasticsearch"
    incus exec mycontainer -- bash -c  "apt update -y && apt install -y elasticsearch"
    echo "Enable and Start Elasticsearch ... triga una mica"
    incus exec mycontainer -- bash -c  "systemctl enable elasticsearch.service --now"
    echo "Install Zammad"
    incus exec mycontainer -- bash -c  "curl -fsSL \"https://go.packager.io/srv/zammad/zammad/stable/installer/ubuntu/24.04.list\" -o /etc/apt/sources.list.d/zammad.list"
    incus exec mycontainer -- bash -c  "apt update && apt install -y zammad"
    echo "Elimina el  lloc Nginx per defecte"
    incus exec mycontainer -- bash -c "ls -la /etc/nginx/sites-enabled/"
    incus exec mycontainer -- bash -c "rm -f /etc/nginx/sites-enabled/default"
    echo "Comprova la configuració de Nginx i reinicia el servei"
    incus exec mycontainer -- bash -c "nginx -t"
    incus exec mycontainer -- bash -c "systemctl restart nginx"
    incus exec mycontainer -- bash -c "curl -I http://localhost/"
}

proxy_incus(){
    ip_addr="127.0.0.1"
    incus config device remove mycontainer http 
    incus config device remove mycontainer https 
    incus config device add mycontainer http proxy listen=tcp:0.0.0.0:80 connect=tcp:${ip_addr}:80
    incus config device add mycontainer https proxy listen=tcp:0.0.0.0:443 connect=tcp:${ip_addr}:443
    ip_wireguard=$(ip -4 -o addr show enp2s0 | awk '{print $4}' | cut -d/ -f1)
    echo "Accedeix a Zammad a la IP de Wireguard-VPN:"
    echo "$ip_wireguard"
}


seguim "Vols acabar (s/n)? "

demana_confirmacio "Vols instal·lar Incus (LXD)? (s/n): " install

demana_confirmacio "Vols crear un contenidor? (s/n): " container

demana_confirmacio "Vols eliminar el contenidor? (s/n): " delete_container

demana_confirmacio "Vols instal·lar Zammad al contenidor? (s/n): " install_zammad

demana_confirmacio "Vols obrir els ports de Incus? (s/n): " proxy_incus
