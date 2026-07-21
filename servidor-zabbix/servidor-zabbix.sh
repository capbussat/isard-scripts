#!/bin/bash
# servidor-zabbix.sh
# sobre debian 12  

# si falla surt de l'script
set -eup

cat << EOF  
Instal·lació del servidor Zabbix.  
Assegur't que tens la configuració de xarxa següent:
enp1s0 default
enp2s0 Wireguard-VPN
enp3s0 Personal1 
EOF
ip -c address show

demanar_confirmacio (){
    echo 
    read -n 1 -p "$1" tecla    
    if [[ $tecla == [sS] ]]; then
        echo "..."
        "$2"
    fi
}

install_zabbix(){
echo "Install Zabbix"
wget https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.4+debian12_all.deb  
dpkg -i zabbix-release_latest_7.4+debian12_all.deb  
apt update -y    
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent  
}

install_mysql(){
echo "Instal·la MySQL database..."    
}

configure_mysql(){  
echo "Configure MySQL database..."    
read -sp "Crea una contrasenya root MySQL: " ROOT_PASS
echo
DB_PASS='password'  
mysql -uroot -p"$ROOT_PASS" << EOF  
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;  
CREATE USER zabbix@localhost IDENTIFIED BY '${DB_PASS}';  
GRANT ALL PRIVILEGES ON zabbix.* TO zabbix@localhost;  
SET GLOBAL log_bin_trust_function_creators = 1;  
EOF  
}

demanar_confirmacio "Vols instal·lar Zabbix?" install_zabbix
demanar_confirmacio "Vols instal·lar MySQL?" install_mysql
demanar_confirmacio "Vols instal·lar MySQL?" configure_mysql
