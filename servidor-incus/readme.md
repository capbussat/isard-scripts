# Incus
Provat en Ubuntu 24.04 Server.  
Preparat per afegir zammad al contenidor.


## Abans de res

sudo git clone https://github.com/capbussat/isard-scripts  
cd isard-scripts  
cd servidor-incus  
sudo chmod +x servidor-incus.sh  
./servidor-incus.sh  

## Incus
Algunes comandes:  
incus list  
incus exec -- bash -c "pwd"  
incus shell mycontainer  

### Snapshots
Algunes comandes:
 incus snapshot create mycontainer snapshot1  
 incus snapshot list mycontainer
 incus snapshot restore mycontainer snapsho1
 incus snapshot delete mycontainer snapshot1  
