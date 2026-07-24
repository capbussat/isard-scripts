#!/bin/bash
# common/menu.sh
# Compatible amb 'set -euo pipefail'
# menu per seleccionar opcions de l'usuari; exemple en client-borg
mostra_menu() {
    echo "Selecciona opcions (ex: 1 3 4), o 'a' per totes:"
    # claus de l'array !MENU_ITEMS[@]
    for i in "${!MENU_ITEMS[@]}"; do
        # talla el text des de l'inici fins els dos punts #*:
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
        # triades[$i]:-  dona el valor triades[$i] o la cadena en blanc
        # %%:* treu la segona part darrera dels dos punts
        [[ -n "${triades[$i]:-}" ]] && "${MENU_ITEMS[$i]%%:*}"
    done
}
