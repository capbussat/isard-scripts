# Client Ubuntu Mate 24.04 Desktop

# Canvia colors
source /etc/os-release 
if [[ "$XDG_CURRENT_DESKTOP" == *"MATE"* && "$NAMEe"=="UBUNTU" && "$VERSION_ID" == "24.04" ]]; then
    echo "Canviant el fons de UBUNTU MATE 24.04"
    gsettings set org.mate.background picture-filename '/usr/share/backgrounds/ubuntu-mate-photos/k>
    PERFIL="/org/mate/terminal/profiles/default/"

    echo "Configurant el perfil de MATE Terminal..."
    dconf write "${PERFIL}use-theme-colors" "false"

    dconf write "${PERFIL}background-color" "'#0B3C11'"
    dconf write "${PERFIL}foreground-color" "'#FFFFFF'"

    dconf write "${PERFIL}bold-color-same-as-fg" "false"
    dconf write "${PERFIL}bold-color" "'#FFFF00'"

   echo "Perfil modificat amb èxit. Obre una nova terminal per veure els canvis!"

else
    echo "No és Ubuntu Mate 24.04. No canvio el fons."
    echo  " Tampoc canvio els colors del terminal."
fi

# Només la xarxa Personal 1 que rep la IP per DHCP del Servidor- router
ip -c a
