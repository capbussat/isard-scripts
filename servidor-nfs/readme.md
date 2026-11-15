# NFS
Scripts per instal·lar un servidor NFS a Ubuntu 26

Hauria de tenir unes connexions (màquina ISARD VDI): 
- enp1s0 default
- enp2s0 Personal1
Instal·lació

sudo apt update -y && sudo apt upgrade 

sudo apt install git

git clone https://github.com/capbussat/isard-scripts/

cd isard-scripts

cd servidor-nfs

chmod +x servidor-nfs.sh

./servidor-nfs.sh

Els clients han de tenir també configurada la xarxa Personal1. 

Per actualitzar a la darrera versió:

git stash; git pull
