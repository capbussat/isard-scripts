#!/bin.bash
# servidor-webmin.sh  
sudo apt update -y   
sudo apt upgrade  
echo "Descarrega webmin ..."  
curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh  
echo "Instal·la webmin ..."  
sudo sh webmin-setup-repo.sh  
sudo apt-get install webmin --install-recommends  
echo "Neteja ..."  
sudo apt autoremove  
echo "Canvia la contrasenya per root:"  
sudo webmin passwd root 
echo "Podeu accedir a la seva interfície introduint firefox localhost:10000 usuari:root amb la contrasenya que has creat."  
echo "Crea els grups i i usuaris necessaris."    
