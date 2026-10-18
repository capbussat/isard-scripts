#!/bin/bash
echo "Servidor-mysql amb Ubuntu 26"

set -euo pipefail

demanar_confirmacio (){
    echo 
    read -n 1 -p "$1" tecla    
    if [[ $tecla == [sS] ]]; then
        echo "..."
        "$2"
    fi
}

xarxa(){
  echo 
  ip address show 
  ip route show
}


demanar_confirmacio "Vols comprovar la xarxa? (s/n)" xarxa
