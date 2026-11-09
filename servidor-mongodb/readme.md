# MongoDB
# PostgreSQL
## Scripts per instal·lar MongoDB a Ubuntu 24

En el moment de crear aquest fitxer no és encara possible instal·lar MongoDB a Ubuntu 26.

Hauria de tenir unes connexions (màquina ISARD VDI):
    enp1s0 default
    enp2s0 Personal1

## Instal·lació
sudo apt update -y && sudo apt upgrade \
sudo apt install git \
git clone https://github.com/capbussat/isard-scripts/servidor-mysql \
cd isard-scripts \
cd servidor-mongodb \
chmod +x # PostgreSQL
## Scripts per instal·lar PostgreSQL a Ubuntu 26

Hauria de tenir unes connexions (màquina ISARD VDI):
    enp1s0 default
    enp2s0 Personal1

## Instal·lació
sudo apt update -y && sudo apt upgrade \
sudo apt install git \
git clone https://github.com/capbussat/isard-scripts/servidor-mysql \
cd isard-scripts \
cd servidor-postgresql \
chmod +x servidor-mongodb.sh \
./servidor-mongodb.sh

Els clients han de tenir també configurada la xarxa Personal1.
Per actualitzar a la darrera versió:

git stash; git pull.sh \
