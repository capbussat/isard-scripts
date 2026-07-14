# servidor-dhcp.sh
# si falla surt de l'script
set -eu
cat << EOF
Servidor DHCP (Ubuntu 24)
Aquest servidor serà el servidor principal.  
Hauria de tenir una connexio   
enp1s0 default  
enp2s0 Wireguard  
enp3s0 Personal1
enp4s0 Personal2 
EOF
sudo apt update -y   
sudo apt upgrade  
sudo apt install kea-dhcp4-server -no-install-recommends  
sudo apt autoremove  
ip -c address show
read -n 1 -p "Comprovem que hi ha enp1s0 amb default enp2s0 wireguard-vpn i dues xarxes persona 1 i personal 2 sense ip. Seguim (s/n)?"  tecla  


