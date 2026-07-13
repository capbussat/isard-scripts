# Proves amb NFT Tables en la màquina Servidor
## Treure netplan
sudo mv /etc/netplan/50-cloud-init.yaml  /etc/netplan/50-cloud-init.yaml.bak
sudo netplan apply

### Hi ha tres xarxes d'isard: enp1s0 default enp2s02 wireguard-vpn i enp3s0 Personal 1
cd /etc/systemd/network/
ls
### Hi ha els fitxer 10.network 20.network i 30.network
### Crea un dhcp en la xarxa 10.10.10.0/24 que comença per 10.10.10.101
cat 10.network; cat 20.network; cat 30.network;

[Match]
Name=enp1s0
[Network]
DHCP=yes

[Match]
Name=enp2s0
[Network]
DHCP=yes

[Match]
Name=enp3s0
[Network]
DHCP=no
Address=10.10.10.1/24
DHCPServer=yes
IPMasquerade=ipv4
[DHCPServer]
PoolOffset=100
PoolSize=20
DNS=1.1.1.1
EmitDNS=yes
EmitRouter=yes
Router=10.10.10.1

### Sistema administrat amb systemd-networkd
sudo systemctl start systemd.networkd
sudo systemctl status systemd-networkd
ip -c a

### Forward el paquet
### sysctl - configure kernel parameters at runtime
sudo sysctl -w net.ipv4.ip_forward=1
### posa  net.ipv4.ip_forward=1 en el fitxer
sudo nano /etc/sysctl.d/99-sysctl.conf
sudo sysctl -p

### resolved
sudo nano /etc/systemd/resolved.conf

### Canvia aquests pràmetres per tenir accés al DNS 
DNS=1.1.1.1
DNSStubListenerExtra=10.10.10.1
ReadEtcHosts=yes

### Pots posar el servidors locals com servidor.cat
sudo nano /etc/hosts

### Inici del servei NFT i llistats (fitxer nftables_ruleset.backup) 
sudo cat nftables_ruleset.backup > /etc/nftables/nftables.conf

sudo systemctl status nftables
sudo nft list tables
sudo nft list ruleset

### Hi ha un NAT masquerade per qualsevol adreça de la xarxa 10.10.10.0/24 pot accedir a internet a traves de enp1s0

### Aquest és l'executable del servei
/usr/sbin/nft -f /etc/nftables.conf

### Hi ha un log en el FILTER al port 80 per servidor http, amb el servidor Nginx funcionant
### Terminal 1
wget localhost:80

### Terminal 2
### Per comprovar nftables
sudo journalctl  -k -f 
sudo dmesg -w | grep "NFT TEST"
