#!/bin/bash

# ──────────────── FUNCIONES ────────────────

spinner() {
    local pid=$!
    local delay=0.15
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

step() {
    echo -ne "🔧 $1..."
}

step_done() {
    echo "✅ Hecho"
}

# ──────────────── INICIO ────────────────

echo "🚀 Configurando Steam como Steam Deck en Arch Linux..."

# 1. Actualización del sistema
step "Actualizando el sistema"
(sudo pacman -Syu --noconfirm) & spinner
step_done

# 2. Instalación de Steam
step "Instalando Steam"
(sudo pacman -S --noconfirm steam) & spinner
step_done

# 3. Instalación de dependencias 32-bit
step "Instalando dependencias de 32 bits"
(sudo pacman -S --noconfirm lib32-mesa lib32-vulkan-icd-loader) & spinner
step_done

# 4. Detectar tarjeta gráfica y drivers
GPU=$(lspci | grep -E "VGA|3D")
if echo "$GPU" | grep -iq "nvidia"; then
    step "Detectada GPU NVIDIA, instalando drivers"
    (sudo pacman -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils) & spinner
    step_done
elif echo "$GPU" | grep -iq "amd"; then
    step "Detectada GPU AMD, instalando drivers"
    (sudo pacman -S --noconfirm mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon) & spinner
    step_done
else
    echo "⚠️ No se detectó GPU NVIDIA ni AMD compatible. Revisa manualmente los drivers."
fi

# 5. Instalar steam-devices y game-devices-udev
step "Instalando soporte para dispositivos Steam"
(sudo pacman -S --noconfirm steam-devices game-devices-udev) & spinner
step_done

# 6. Configurar entorno tipo Steam Deck
step "Configurando variables de entorno para Steam Deck"
mkdir -p ~/.steam

ENV_FILE=~/.steam/steam_env.sh
cat <<EOF > "$ENV_FILE"
export SteamDeck=1
export STEAM_DECK=1
export STEAM_FORCE_STEAMDECK=1
export DECK_FORCE_STEAM_RUNTIME=1
export STEAM_FORCE_DESKTOPUI=0
EOF

# Añadirlo a .bashrc si no está
if ! grep -q "steam_env.sh" ~/.bashrc; then
    echo "source ~/.steam/steam_env.sh" >> ~/.bashrc
fi
step_done

# 7. Crear alias para lanzar Steam en modo Deck
step "Creando alias 'steamdeck'"
if ! grep -q "alias steamdeck=" ~/.bashrc; then
    echo "alias steamdeck='STEAM_FORCE_STEAMDECK=1 steam -gamepadui'" >> ~/.bashrc
fi
step_done

# 8. Cargar configuración actual sin reinicio
step "Aplicando configuración"
source ~/.bashrc &> /dev/null
step_done

# ──────────────── FIN ────────────────

echo ""
echo "🎉 ¡Configuración completada!"
echo "✅ Ejecuta Steam con: steamdeck"
echo "ℹ️ Recuerda reiniciar tu sesión o ejecutar 'source ~/.bashrc' para aplicar todo correctamente."
