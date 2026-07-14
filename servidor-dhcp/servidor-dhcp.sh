# servidor-dhcp.sh
# si falla surt de l'script
set -eu
sudo apt update -y   
sudo apt upgrade  
sudo apt install kea-dhcp4-server -no-install-recommends  
sudo apt autoremove  
ip -c address show
read -n 1 -p "Comprovem que hi ha enp1s0 amb default enp2s0 wireguard-vpn i dues xarxes persona 1 i personal 2 sense ip. Seguim (s/n)?"  tecla  


