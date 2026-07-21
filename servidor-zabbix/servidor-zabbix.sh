# servidor-zabbix.sh
# sobre debian 12  

wget https://repo.zabbix.com/zabbix/7.4/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_7.4+debian12_all.deb  
dpkg -i zabbix-release_latest_7.4+debian12_all.deb  
apt update -y    
