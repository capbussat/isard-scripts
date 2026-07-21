# Zabbix (Client Ubuntu)
Zabbix és una plataforma de monitorització de codi obert per a xarxes, servidors, màquines virtuals i serveis en el núvol. Recull mètriques a través de SNMP, IPMI, JMX i agents personalitzats, a continuació, emmagatzema les dades en una base de dades relacional i proporciona alerta, visualització i informes a través d'un frontend basat en web.

Install Zabbix
https://www.zabbix.com/download?zabbix=7.4&os_distribution=debian&os_version=12&components=server_frontend_agent&db=mysql&ws=apache

## Si és el client, només selecciona l'agent:
sudo -s 
wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu24.04_all.deb
dpkg -i zabbix-release_latest_7.4+ubuntu24.04_all.deb
apt update -y && apt install zabbix-agent 

### Engega:
systemctl enable now zabbix-agent 

### Si tens Wireguard VPN activada ves a la url <ip-servidor>/zabbix per veure el tauler
