🚀 Instalación de Steam en Arch Linux + Compatibilidad Steam Deck 🎮🐧
Esta guía te mostrará cómo instalar Steam en Arch Linux y configurar tu sistema para que Steam lo detecte como una Steam Deck, lo cual puede mejorar la compatibilidad con ciertos juegos y habilitar características exclusivas.

📦 Paso 1: Actualiza tu sistema
Primero actualiza todos los paquetes del sistema:

Arch

```
sudo pacman -Syu
```

Ubuntu

```
sudo apt update && sudo apt upgrade
```

🎮 Paso 2: Instalación de Steam
Instala Steam desde los repos oficiales:

Arch

```
sudo pacman -S steam
```

Ubuntu

```
sudo apt install steam
sudo add-apt-repository multiverse // es posible que necesites también estos paquetes
sudo apt update
```

🔧 Paso 3: Instala dependencias adicionales (compatibilidad 32-bit)
Para maximizar la compatibilidad con juegos:

Arch

```
sudo pacman -S lib32-mesa lib32-vulkan-icd-loader
```

Ubuntu

```
sudo dpkg --add-architecture i386
sudo apt update
```

💻 Tarjetas gráficas NVIDIA
Instala los drivers necesarios si usas NVIDIA:

Arch

```

sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils

```

Ubuntu

```
ubuntu-drivers devices
sudo ubuntu-drivers autoinstall
```

🖥️ Tarjetas gráficas AMD
En caso de usar AMD:

Arch

```

sudo pacman -S mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon

```

Ubuntu

```
sudo apt install mesa-vulkan-drivers mesa-vulkan-drivers:i386
```

🧩 Paso 4: Habilita Steam Play / Proton
Inicia Steam al menos una vez:

```

steam

```

Ve a:
Steam > Configuración > Steam Play
Activa:

✔️ Habilitar Steam Play para todos los títulos

Selecciona una versión de Proton (por ejemplo: Proton Experimental)

🎭 Paso 5: Hacer que Steam detecte tu sistema como una Steam Deck
Esto se logra modificando una variable de entorno de Steam para simular el entorno de una Steam Deck:

1. Crear archivo de configuración personalizado para Steam
   Crea (o edita) el archivo:

```

~/.steam/steam.sh

```

Agrega al inicio del archivo:

```

export SteamDeck=1
export STEAM_DECK=1
export DECK_FORCE_STEAM_RUNTIME=1
export STEAM_FORCE_DESKTOPUI=0
export STEAM_FORCE_STEAMDECK=1 2.

```

Alternativamente, puedes iniciar Steam con estas variables así:

```

SteamDeck=1 STEAM_DECK=1 STEAM_FORCE_STEAMDECK=1 steam

```

📦 Paso 6: Instalar Steam Runtime y modo Big Picture UI de Steam Deck
Steam Deck utiliza su propio entorno de ejecución. En Arch, puedes forzarlo así:

Instalar steam-devices (permite soporte completo de controladores de Steam Deck)

Arch

```

sudo pacman -S steam-devices

```

Ubuntu

```
sudo apt install steam-devices
```

Lanza Steam con interfaz de Steam Deck (modo gaming de Big Picture actualizado):

```

STEAM_FORCE_STEAMDECK=1 steam -gamepadui

```

Para hacerlo permanente, puedes crear un archivo .desktop personalizado o alias en tu ~/.bashrc:

```

alias steamdeck="STEAM_FORCE_STEAMDECK=1 steam -gamepadui"

```

🛠️ Paso 7: Asegurar compatibilidad de controladores y entrada
Para imitar completamente la Steam Deck, se recomienda:

Arch

```

sudo pacman -S game-devices-udev steam-devices

```

Ubuntu

```
sudo apt install flatpak
flatpak install flathub com.valvesoftware.Steam
```

Opción B (Ubuntu)
Puedes crear un archivo de reglas udev

```
sudo tee /etc/udev/rules.d/99-gamecontrollers.rules > /dev/null <<EOF
# Valve Corporation
SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"

# Xbox Controllers
SUBSYSTEM=="input", GROUP="input", MODE="0660"
SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", MODE="0666"

# Sony Controllers (DualShock)
SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", MODE="0666"

# Nintendo Controllers
SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", MODE="0666"
EOF
```

🚦 Paso 8: Ejecuta Steam como una Steam Deck
Ya puedes lanzar Steam con detección de entorno tipo Deck:

```

steamdeck

```

💡 Consejos adicionales
Si usas controladores personalizados (como el de Steam Deck en modo USB-C), instala también gamescope.

Si experimentas errores gráficos, prueba versiones experimentales de Proton (Proton GE) desde ProtonUp-Qt.

Puedes instalar protonup-qt desde AUR:

Arch

```

yay / paru -S protonup-qt

```

Ubuntu

```
flatpak install flathub net.davidotek.pupgui2
```

✅ Confirmación de entorno tipo Deck
Puedes confirmar si Steam detecta tu entorno como una Steam Deck:

Ve a steam://open/console en tu navegador o barra de direcciones de Steam.

En la consola, ejecuta:

```

echo $SteamDeck

```

Debería devolver 1.

📜 Instrucciones de uso de script
Guarda (o clona el repositorio) el script en un archivo, por ejemplo:

Arch

```

nano setup_steamdeck.sh

```

Ubuntu

```
nano ubuntu_setup_steamdeck.sh
```

Hazlo ejecutable:

```

chmod +x setup_steamdeck.sh

```

Ejecuta el script:

```

./setup_steamdeck.sh

```

```

```
