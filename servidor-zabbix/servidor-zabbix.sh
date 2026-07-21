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
sudo dpkg -i zabbix-release_latest_7.4+debian12_all.deb  
sudo apt update -y    
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent  
}

install_mysql(){
echo "Instal·la MySQL database..."    
sudo apt install mariadb-server mariadb-client
}

configure_mysql(){  
echo "Configure MySQL database..."    
read -sp "Crea una contrasenya root MySQL: " ROOT_PASS
echo
DB_PASS="pirineus"  
sudo mysql -uroot -p"$ROOT_PASS" << EOF  
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;  
CREATE USER zabbix@localhost IDENTIFIED BY '${DB_PASS}';  
GRANT ALL PRIVILEGES ON zabbix.* TO zabbix@localhost;  
SET GLOBAL log_bin_trust_function_creators = 1;  
EOF  
echo "Inicialitza l'esquema de la BD. Entra la nova contrasenya que has creat. "
sudo zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | sudo mysql --default-character-set=utf8mb4 -uzabbix -p zabbix 
echo "Canvia aquesta configuració ..."
sudo mysql -uroot -p
cat << EOF
set global log_bin_trust_function_creators = 0;
quit;
EOF
echo "Segueix la configuració del fitxer ..."
CONF=/etc/zabbix/zabbix_server.conf
echo "$CONF"
if grep -q "^DBPassword=" "$CONF"; then
    sed -i "s/^DBPassword=.*/DBPassword=${DB_PASS}/" "$CONF"
elif grep -q "^# DBPassword=" "$CONF"; then
    sed -i "s/^# DBPassword=.*/DBPassword=${DB_PASS}/" "$CONF"
else
    echo "DBPassword=${DB_PASS}" >> "$CONF"
fi
}

demanar_confirmacio "Vols instal·lar Zabbix?" install_zabbix
demanar_confirmacio "Vols instal·lar MySQL?" install_mysql
demanar_confirmacio "Vols instal·lar MySQL?" configure_mysql
