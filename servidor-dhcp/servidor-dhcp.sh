# servidor-dhcp.sh
# si falla surt de l'script
set -eu

# Xarxa Personal 1
IFACE="enp3s0"

cat << EOF
Servidor DHCP (Ubuntu 24)
Aquest servidor serà el servidor principal.  
Hauria de tenir una connexio   
enp1s0 Default  
enp2s0 Wireguard  
enp3s0 Personal1
enp4s0 Personal2 
EOF

install(){  
sudo hostnamectl set-hostname "servidor-dhcp"
sudo apt update -y   
sudo apt upgrade  
sudo apt install kea-dhcp4-server 
sudo apt autoremove  
}

configure(){
    if [[ -f /etc/kea/kea-dhcp4.conf.bak  ]]; then
      echo "El fitxer de configuració ja existeix. No es sobre-escriu la còpia de seguretat."
    else 
        sudo cp /etc/kea/kea-dhcp4.conf /etc/kea/kea-dhcp4.conf.bak
    fi
   sudo cp kea-dhcp4.conf  /etc/kea/kea-dhcp4.conf
   cat /etc/kea/kea-dhcp4.conf | jq '.'
   sudo systemctl restart kea-dhcp4-server
   sudo systemctl enable kea-dhcp4-server
   sudo systemctl status kea-dhcp4-server
}

network(){
    sudo mv /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak
    sudo cp netplan.yaml /etc/netplan/10-cloud-init.yaml
    sudo chmod 600 /etc/netplan/10-cloud-init.yaml
    sudo netplan apply
}

router(){
    echo "Configurant IP forwarding..."
    echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/99-ipforward.conf
    sudo sysctl --system

    echo "Instal·lant paquets nftables..."
    sudo apt update -y && sudo apt install  nftables
    echo "Aplicant la configuració de nftables..."
    sudo cp nftables.conf /etc/nftables.conf
    sudo nft -f /etc/nftables.conf
    sudo systemctl restart nftables
    sudo systemctl enable nftables
    sudo systemctl status nftables   
}

mostra_xarxa(){
    echo "Mostrant la configuració de xarxa..."
    ip -c addr show
    echo "Mostrant les rutes..."
    ip -c route show
}

demanar_confirmacio (){
    echo 
    read -n 1 -p "$1" tecla    
    if [[ $tecla == [sS] ]]; then
        echo "..."
        "$2"
    fi
}


demanar_confirmacio  "Actulitza i instal·la els paquets del servidor KEA DHCP? (s/n)" install

demanar_confirmacio  "Comprova enp1s0 per Default, enp2s0 Wireguard-VPN, i dues xarxes Personal1 i Personal2 sense ip. Seguim (s/n)?" mostra_xarxa

demanar_confirmacio  "Configura la xarxa (s/n)?" network

demanar_confirmacio  "Configura el servidor DHCP (s/n)?" configure

demanar_confirmacio  "Configura el router (s/n)?" router

echo "Configuració completa."
