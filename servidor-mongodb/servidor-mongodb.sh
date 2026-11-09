#!/usr/bin/env bash
# Instal·la MongoDB 8.0 Community a Ubuntu 24.04 (Noble)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADDR="192.168.37.71/24"

clear
echo "Fitxer d'instal·lació MOngoDB:"

instala_mongodb(){
  sudo apt-get update -y && sudo apt-get install -y gnupg curl  \
  curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
  sudo gpg --yes --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg


  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | \
  sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list

  sudo apt-get update -y && sudo apt-get install -y mongodb-org

  sudo systemctl daemon-reload
  sudo systemctl enable --now mongod

  sudo systemctl status mongod --no-pager
  mongosh --eval 'db.runCommand({ ping: 1 })'

}

surt(){
echo "Adéu";
}

# usa script ../common/menu.sh
source "$SCRIPT_DIR/../common/menu.sh"

declare -a MENU_ITEMS=(
  "instala_mongodb:Vols instal·lar MongoDB?"
  "surt:Vols sortir?"
)
