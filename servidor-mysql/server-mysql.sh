#!/bin/bash
set -euo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADDR="192.168.37.2/24"

clear

instala_mysql(){
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install mysql-server -y
    mysql -V
    sudo systemctl status mysql
}

crea_bbdd_alumnes_i_crea_usuari_isard(){
if [ ! -f $SCRIPT_DIR/crea_bbdd_alumnes.sql ]; then
cat > "$SCRIPT_DIR/crea_bbdd_alumnes.sql" << EOF
CREATE DATABASE IF NOT EXISTS alumnes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS alumnes.alumnes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    telefon VARCHAR(20),
    email VARCHAR(255),
    data_naixement DATE,
    curs VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
EOF
    sudo chmod 600  $SCRIPT_DIR/crea_bbdd_alumnes.sql;
    sudo mysql <  $SCRIPT_DIR/crea_bbdd_alumnes.sql;
    echo "Executat $SCRIPT_DIR/crea_bbdd_alumnes.sql"
fi

if [ ! -f $SCRIPT_DIR/crea_usuari_isard.sql ]; then
cat > "$SCRIPT_DIR/crea_usuari_isard.sql" << EOF
-- crea_usuari_isard.sql
CREATE USER IF NOT EXISTS 'isard'@'192.168.37.2' IDENTIFIED BY 'pirineus';
GRANT ALL PRIVILEGES ON alumnes.* TO 'isard'@'192.168.37.2';
FLUSH PRIVILEGES;
EOF
    sudo chmod 600 $SCRIPT_DIR/crea_usuari_isard.sql;
    sudo mysql <  $SCRIPT_DIR/crea_usuari_isard.sql;
    echo "Executat $SCRIPT_DIR/crea_usuari_isard.sql"
fi
}

actualitza_xarxa(){
if [ -f "/etc/netplan/99-isardvdi-conf.yaml" ]; then 
    echo "Fent backup"
    sudo mv /etc/netplan/99-isardvdi-conf.yaml /etc/netplan/99-isardvdi-conf.yaml.bak
fi

if [ ! -f "/etc/netplan/99-isardvdi-conf2.yaml" ]; then 
    echo "Crea el nou fitxer a netplan."
    cat > "/etc/netplan/99-isardvdi-conf2.yaml" <<EOF
network:
  version: 2
  ethernets:
    enp1s0: 
      dhcp4: true
      dhcp6: false
    enp2s0:
      dhcp4: false
      dhcp6: false
      addresses:
        - ${ADDR}
EOF
    chmod 600 /etc/netplan/99-isardvdi-conf2.yaml
    netplan apply
else
    echo "No cal actualitzar la configuració de netplan"
fi
}

xarxa(){
  echo 
  ip address show
  echo 
  ip route show
}

permet_access(){
    echo "Permet acces des de qualsevol adreça"
    sudo sed -i.bak 's/^bind-address\s*=\s*127\.0\.0\.1/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysld.cnf
    sudo sed -i.bak 's/^bind-address\s*=\s*127\.0\.0\.1/mysqlx-bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysld.cnf
    echo "Reinicia MySQL"
    sudo systemctl restart mysql
}

# usa script ../common/menu.sh
source "$SCRIPT_DIR/../common/menu.sh"

declare -a MENU_ITEMS=(
    "actualitza_xarxa:Vols canviar la xarxa?"
    "xarxa:Vols comprovar la xarxa?"
    "instala_mysql:Vols instal·lar el servidor MySQL?"
    "crea_bbdd_alumnes_i_crea_usuari_isard:Vols crear la base de dades alumnes i l'usuari isard?"
    "permet_access:Permet acces a MySQL des de qualsevol adreça?"
    "surt:Vols sortir?"
)

mostra_menu
read -ra opcio
executa_seleccio "${opcio[@]}"
