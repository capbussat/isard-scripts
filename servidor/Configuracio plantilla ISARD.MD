# Configuració inicial plantilla ISARD
sudo apt update -y
sudo apt upgrade -y
sudo apt install vim net-tools htop curl wget spice-vdagent qemu-guest-agent
sudo nano /etc/fstab 
scd /
cd /
sudo fstrim -a -v
sudo sysctl vm.swappiness=1
sudo nano /etc/systemd/journald.conf
sudo apt purge update-manager update-notifier*
sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
sudo nano /etc/update-manager/release-upgrades
sudo snap refresh --hold
sudo snap set system refresh.retain=3
reboot
netstat -tlnp
poweroff