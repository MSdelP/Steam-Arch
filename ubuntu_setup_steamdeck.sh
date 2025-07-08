#!/bin/bash

# ──────────────── FUNCIONES ────────────────

spinner() {
    local pid=$!
    local delay=0.15
    local spinstr='|/-\'
    while ps -p $pid > /dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
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

echo "🚀 Configurando Steam como Steam Deck en Ubuntu..."

# 1. Actualización del sistema
step "Actualizando el sistema"
(sudo apt update && sudo apt upgrade -y) & spinner
step_done

# 2. Instalación de Steam
step "Instalando Steam"
(sudo apt install -y steam) & spinner
step_done

# 3. Habilitar arquitectura i386 para dependencias 32-bit
step "Habilitando arquitectura i386"
(sudo dpkg --add-architecture i386 && sudo apt update) & spinner
step_done

# 4. Instalación de dependencias 32-bit Vulkan y Mesa
step "Instalando dependencias 32-bit Vulkan y Mesa"
(sudo apt install -y libgl1-mesa-glx:i386 libvulkan1:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386) & spinner
step_done

# 5. Detectar tarjeta gráfica y drivers
GPU=$(lspci | grep -E "VGA|3D")
if echo "$GPU" | grep -iq "nvidia"; then
    step "Detectada GPU NVIDIA, instalando drivers"
    (sudo ubuntu-drivers autoinstall) & spinner
    # Instalar soporte 32-bit para NVIDIA
    # Extraemos versión instalada
    NV_VER=$(dpkg -l | grep nvidia-driver | awk '{print $2}' | grep -oP '\d+')
    if [ -n "$NV_VER" ]; then
        sudo apt install -y "libnvidia-gl-$NV_VER:i386"
    else
        sudo apt install -y libnvidia-gl-535:i386  # fallback común
    fi
    step_done
elif echo "$GPU" | grep -iq "amd"; then
    step "Detectada GPU AMD, instalando drivers Mesa y Vulkan"
    (sudo apt install -y mesa-vulkan-drivers mesa-vulkan-drivers:i386) & spinner
    step_done
else
    echo "⚠️ No se detectó GPU NVIDIA ni AMD compatible. Revisa manualmente los drivers."
fi

# 6. Configurar reglas udev para dispositivos Steam y gamepads
step "Configurando reglas udev para dispositivos Steam"
sudo tee /etc/udev/rules.d/99-gamecontrollers.rules > /dev/null <<EOF
# Valve Corporation Steam Controller
SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"

# Xbox Controllers
SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", MODE="0666"

# Sony Controllers (DualShock)
SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", MODE="0666"

# Nintendo Controllers
SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", MODE="0666"

# Permisos para uinput
KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
EOF
sudo udevadm control --reload-rules && sudo udevadm trigger
step_done

# 7. Configurar entorno tipo Steam Deck
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

# 8. Crear alias para lanzar Steam en modo Deck
step "Creando alias 'steamdeck'"
if ! grep -q "alias steamdeck=" ~/.bashrc; then
    echo "alias steamdeck='STEAM_FORCE_STEAMDECK=1 steam -gamepadui'" >> ~/.bashrc
fi
step_done

# 9. Cargar configuración actual sin reinicio
step "Aplicando configuración"
source ~/.bashrc &> /dev/null
step_done

# ──────────────── FIN ────────────────

echo ""
echo "🎉 ¡Configuración completada!"
echo "✅ Ejecuta Steam con: steamdeck"
echo "ℹ️ Recuerda reiniciar tu sesión o ejecutar 'source ~/.bashrc' para aplicar todo correctamente."
