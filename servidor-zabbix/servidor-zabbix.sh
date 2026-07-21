#!/bin/bash
# servidor-zabbix.sh
# sobre debian 12  

# si falla surt de l'script
set -eup

DB_PASS="pirineus"
ROOT_PASS="pirineus"

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
wget https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.4+debian13_all.deb  
sudo dpkg -i zabbix-release_latest_7.4+debian13_all.deb  
sudo apt update -y    
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent  
}

install_mysql(){
echo "Instal·la MySQL database..."    
sudo apt install mariadb-server mariadb-client
sudo mysql -ppirineus 
}

configure_mysql(){  
echo "Configure MySQL database..."    
echo "Les dues contrasenyes són pirineus"
# Si poso -uroot, no sé perquè necessita sudo "
sudo mysql -uroot -p -e "CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin; CREATE USER zabbix@localhost IDENTIFIED BY zabbix; "
sudo mysql -uroot -p -e  "GRANT ALL PRIVILEGES ON zabbix.* TO zabbix@localhost; SET GLOBAL log_bin_trust_function_creators = 1;"
echo "Inicialitza l'esquema de la BD zabbix. Entra la contrasenya de sudo, si és necesssari. Trigarà. "
sudo zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | sudo mysql --default-character-set=utf8mb4 -uzabbix -pzabbix zabbix 
echo "Desactiva aquet permís per usuaris sense el privilegi..."
sudo mysql -uroot -p -e "set global log_bin_trust_function_creators = 0;"
}

start_service(){
echo "Segueix la configuració del fitxer /etc/zabbix/zabbix_server.conf"
echo "Afegeix la línia DBPassword=${DB_PASS}"
echo "L'usuari administrador serà Admin/zabbix"
read -n 1 -p "Prem una tecla qualsevol " tecla
sudo nano /etc/zabbix/zabbix_server.conf
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2 
}

demanar_confirmacio "1 -Vols instal·lar Zabbix?" install_zabbix
demanar_confirmacio "2- Vols instal·lar MySQL?" install_mysql
demanar_confirmacio "3- Vols Configurar MySQL per Zabbix?" configure_mysql
demanar_confirmacio "4 -Vols engegar el servei?" start_service
