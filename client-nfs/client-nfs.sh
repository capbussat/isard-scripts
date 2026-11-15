# Client NFS

# Comprova errors
set -euo pipefail
SERVER_DIRECTORY="/srv/shared" 
LOCAL_DIRECTORY="/home/shared"

echo "Instal·la nfs client"
sudo apt update && sudo apt install nfs-common
echo "Crea el directori"
sudo mkdir "$LOCAL_DIRECTORY"
echo "Canvia el propietari del directori $LOCAL_DIRECTORY"
sudo chown isard:isard /home/shared
echo "Monta el directori $LOCAL_DIRECTORY"
sudo mount 192.168.1.1:$SERVER_DIRECTORY "$LOCAL_DIRECTORY"
ls -l "$LOCAL_DIRECTORY"
