#!/bin/bash
# common/menu.sh
# Compatible amb 'set -euo pipefail'

mostra_menu() {
    echo "Selecciona opcions (ex: 1 3 4), o 'a' per totes:"
    for i in "${!MENU_ITEMS[@]}"; do
        printf "  %d) %s\n" "$((i+1))" "${MENU_ITEMS[$i]#*:}"
    done
}

executa_seleccio() {
    local seleccio=("$@")
    local -A triades=()

    if [[ "${seleccio[0]:-}" == "a" ]]; then
        for i in "${!MENU_ITEMS[@]}"; do triades[$i]=1; done
    else
        for n in "${seleccio[@]}"; do
            [[ "$n" =~ ^[0-9]+$ ]] && (( n>=1 && n<=${#MENU_ITEMS[@]} )) && triades[$((n-1))]=1
        done
    fi

    for i in "${!MENU_ITEMS[@]}"; do
        [[ -n "${triades[$i]:-}" ]] && "${MENU_ITEMS[$i]%%:*}"
    done
}
