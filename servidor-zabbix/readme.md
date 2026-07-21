# Servidor Zabbix 
Debian 12 Server

enp1s0 Default  
enp2s0 Wireguard-vpn  
enp2s0  Personal1  

## Zabbix 
Zabbix és una plataforma de monitorització de codi obert per a xarxes, servidors, màquines virtuals i serveis en el núvol.   
Recull mètriques a través de SNMP, IPMI, JMX i agents personalitzats, a continuació, emmagatzema les dades en una base de dades relacional i proporciona alerta, visualització i informes a través d'un frontend basat en web.

## Install Zabbix
Pots escollir les opcions en la seva web i baixar-te els scripts. Aqui amb Mariadb i Apache.
https://www.zabbix.com/download?zabbix=7.4&os_distribution=debian&os_version=12&components=server_frontend_agent&db=mysql&ws=apache


### Si tens Wireguard VPN activada 
Ves a la url <servidor-zabbix-ip>/zabbix per veure el tauler.  

### Abans de res:  
sudo apt update -y && sudo apt install git -y  
git clone https://github.com/capbussat/servidor-zabbix  
sudo chmod + servidor-zabbix.sh  
./servidor-zabbix.sh  

