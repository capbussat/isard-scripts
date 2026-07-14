# Servidor DHCP
Fem un servidor DHCP en un router amb ISC KEA.  
Aquest servidor serà el servidor principal.  
Hauria de tenir unes connexions:     
- enp1s0 default  
- enp2s0 Wireguard-vpn
- enp3s0 Personal1
- enp4s0 Personal2 

## Instal·lació
sudo apt update -y  
sudo apt install git  
git clone https://github.com/capbussat/isard-scripts  
cd isard-scripts  
cd servidor-dhcp  
chmod +x servidor-dhcp.sh  
./servidor-dhcp.sh  

Engega els clients després d'haver instal·lat el servidor DHCP.
El client ha de tenir la xarxa Personal1.
