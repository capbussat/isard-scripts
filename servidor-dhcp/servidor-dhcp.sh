# servidor-dhcp.sh
sudo apt update -y   
sudo apt upgrade  
sudo apt install kea-dhcp4-server -no-install-recommends  
sudo apt autoremove  
