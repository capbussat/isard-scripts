#!/bin/bash
# servidor-zabbix.sh
# sobre debian 12  
DB_PASS='password'


echo "Install Zabbix"
wget https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.4+debian12_all.deb  
dpkg -i zabbix-release_latest_7.4+debian12_all.deb  
apt update -y    
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent  

echo "Install MySQL database..."  

mysql -uroot -p"$ROOT_PASS" <<EOF
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER zabbix@localhost IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON zabbix.* TO zabbix@localhost;
SET GLOBAL log_bin_trust_function_creators = 1;
EOF
