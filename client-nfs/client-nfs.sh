# Client NFS
# Comprova errors

echo "Instal·la nfs client"
sudo apt update && sudo apt install nfs-common
echo "Crea el directori"
sudo mkdir /home/shared
echo "Canvia el propietari del directori"
sudo chown isard:isard /home/shared
echo "Monta el directori"
sudo mount 192.168.1.1:/srv/shared /home/shared
ls -l /home/shared
