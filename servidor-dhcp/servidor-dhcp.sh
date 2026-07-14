# servidor-dhcp.sh
# si falla surt de l'script
set -eu

# Xarxa Personal 1
IFACE="enp3s0"

cat << EOF
Servidor DHCP (Ubuntu 24)
Aquest servidor serà el servidor principal.  
Hauria de tenir una connexio   
enp1s0 default  
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
    if [ -f /etc/kea/kea-dhcp4.conf.bak  ]]; then
      echo "El fitxer de configuració ja existeix. No es sobre-escriu la còpia de seguretat."
    else 
        sudo mv /etc/kea/kea-dhcp4.conf /etc/kea/kea-dhcp4.conf.bak
    fi
   sudo cat kea-dhcp4.conf > /etc/kea/kea-dhcp4.conf
   cat /etc/kea/kea-dhcp4.conf | jq '.'
   sudo systemctl restart kea-dhcp4-server
   sudo systemctl status kea-dhcp4-server
}

read -n 1 -p "Actulitza i instal·lació del paquets del servidor KEA DHCP? (s/n)" tecla
if [[ $tecla == [sS] ]]; then
    echo ""
    install
fi
echo "..."
read -n 1 -p "Comprovem que hi ha enp1s0 amb default enp2s0 wireguard-vpn i dues xarxes persona 1 i personal 2 sense ip. Seguim (s/n)?"  tecla  
if [[ $tecla == [sS] ]]; then
    ip -c address show
fi 
echo "..."

read -n 1 -p "Configura DHCP4 a la xarxa personal 1 (enp3s0). Seguim (s/n)?" tecla
if [[ $tecla == [sS] ]]; then
    configure
fi
echo "Configuració completa."
