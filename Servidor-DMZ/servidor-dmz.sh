cat << EOF
Servidor DMZ
Hauria de tenir una connexio enp1s0 Wireguard
farem Una connexió enp2s0 manual. Aquest servidor estarà connectat al Servidor-router. 
Tindrà una xarxa interna 192.168.10.0/24 La IP manual del servidor DMZ 192.168.10.2/24.
Aquest Debian Server 13 està configurat amb Network Manager amb nmtui?"
EOF
echo "systemctl is-active NetworkManager"
systemctl is-active NetworkManager 
echo "systemctl is-active systemd-networkd"
systemctl is-active systemd-networkd 
read -n 1  -p "Comprovem les connexions prem qualsevol tecla CTRL+C per sortir" tecla
nmcli connection show
# la connexió "internet" és enp2s0 amb Address=192.168.10.2 Gateway=192.168.10.1 i DNS=1.1.1.1.
read -n 1  -p "Prem qualsevol tecla per continuar CTRL+C per sortir" tecla
sudo nmcli connection modify "internet" connection.interface-name enp2s0;
sudo nmcli connection modify "internet" ipv4.addresses 192.168.10.2/24 ipv4.gateway 192.168.10.1 ipv4.dns 1.1.1.1;
sudo nmcli connection up "internet";

echo "Actualitza i instal·la Nginx"
read -n 1  -p "Prem qualsevol tecla per continuar CTRL+C per sortir" tecla
sudo apt update -y && sudo apt upgrade
sudo apt install nginx
sudo apt autoremove
echo "Comprova  nginx"
sudo systemctl status nginx

echo "Comprova ping 192.168.10.1 gateway"
ping -c 4 192.168.10.1
echo "Comprova  ping 10.10.10.1 router, per l'altra xarxa"
ping -c 4 10.10.10.1
echo "Comprova accés a internet"
ping -c 4 1.1.1.1
echo "Comprova  ping 10.10.10.111 ( que no pots arribar a la LAN)"
ping -c 4 10.10.10.111
