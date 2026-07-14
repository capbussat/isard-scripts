# Client Ubuntu Mate 24.04 Desktop

escriptori(){
    # 1. Detectar automàticament la ruta de l'escriptori (funciona en >
    if [ -d "$HOME/Escriptori" ]; then
        DESKTOP_DIR="$HOME/Escriptori"
    elif [ -d "$HOME/Escritorio" ]; then
        DESKTOP_DIR="$HOME/Escritorio"
    else
        DESKTOP_DIR="$HOME/Desktop"
        mkdir -p "$DESKTOP_DIR"
    fi

    echo "Creant enllaços a: $DESKTOP_DIR"
    
    # 2. Crear l'enllaç de la Terminal
    cat <<EOF > "$DESKTOP_DIR/Terminal.desktop"
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Terminal
    Comment=Obre la terminal de comandos
    Exec=mate-terminal
    Icon=utilities-terminal
    Terminal=false
    Categories=System;TerminalEmulator;
    EOF

    # 3. Crear l'enllaç de Firefox
    cat <<EOF > "$DESKTOP_DIR/Firefox.desktop"
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Firefox
    Comment=Navegador web Firefox
    Exec=firefox
    Icon=firefox
    Terminal=false
    Categories=Network;WebBrowser;
    EOF
}
    

# Canvia colors
colors(){
    source /etc/os-release 
    if [[ "$XDG_CURRENT_DESKTOP" == *"MATE"* && "$ID" == "UBUNTU" && "$VERSION_ID" == "24.04" ]]; then
        echo "Canviant el fons de UBUNTU MATE 24.04"
        gsettings set org.mate.background picture-filename '/usr/share/backgrounds/ubuntu-mate-photos/kristopher-roller-110203.jpg'
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
}

xarxa(){
echo "Només la xarxa Personal 1 que rep la IP per DHCP del Servidor- router"
ip -c a

}

colors
escriptori
xarxa


