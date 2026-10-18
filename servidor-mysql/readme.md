# Servidor MySQL
Fem un servidor MySQL a Ubuntu Server 26.  
Aquest servidor serà el servidor principal.  
Hauria de tenir unes connexions (màquina ISARD VDI):     
- enp1s0 default  
- enp2s0 Personal1

## Instal·lació
sudo apt update -y && sudo apt upgrade
sudo apt install git
git clone https://github.com/capbussat/isard-scripts/servidor-mysql  
cd isard-scripts  
cd servidor-mysql  
chmod +x servidor-mysql.sh  
./servidor-mysql.sh  

El client ha de tenir també la xarxa Personal1
