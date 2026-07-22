#!/bin.bash
# servidor-webmin.sh

curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh  
sudo sh webmin-setup-repo.sh  
sudo apt-get install webmin --install-recommends
echo " Canvia la contrasenya per root:"
sudo webmin passwd root 
echo "Podeu accedir a la seva interfície introduint firefox localhost:10000 usuari root"  
echo "Crea els grups i i usaris necessaris"    
