# Client NFS

# Comprova errors

DIRECTORY="/home/shared"
echo "Instal·la nfs client"
sudo apt update && sudo apt install nfs-common
echo "Crea el directori"
sudo mkdir "$DIR"
echo "Canvia el propietari del directori $DIR"
sudo chown isard:isard /home/shared
echo "Monta el directori $DIR"
sudo mount 192.168.1.1:/srv/shared  "$DIR"
ls -l "$DIR"
