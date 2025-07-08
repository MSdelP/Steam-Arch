🚀 Instalación de Steam en Arch Linux + Compatibilidad Steam Deck 🎮🐧
Esta guía te mostrará cómo instalar Steam en Arch Linux y configurar tu sistema para que Steam lo detecte como una Steam Deck, lo cual puede mejorar la compatibilidad con ciertos juegos y habilitar características exclusivas.

📦 Paso 1: Actualiza tu sistema
Primero actualiza todos los paquetes del sistema:

```
sudo pacman -Syu
```

🎮 Paso 2: Instalación de Steam
Instala Steam desde los repos oficiales:

```
sudo pacman -S steam
```

🔧 Paso 3: Instala dependencias adicionales (compatibilidad 32-bit)
Para maximizar la compatibilidad con juegos:

```
sudo pacman -S lib32-mesa lib32-vulkan-icd-loader
```

💻 Tarjetas gráficas NVIDIA
Instala los drivers necesarios si usas NVIDIA:

```
sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils
```

🖥️ Tarjetas gráficas AMD
En caso de usar AMD:

```
sudo pacman -S mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon
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

```
sudo pacman -S steam-devices
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

```
sudo pacman -S game-devices-udev steam-devices
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

```
yay -S protonup-qt
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

```
nano setup_steamdeck.sh
```

Hazlo ejecutable:

```
chmod +x setup_steamdeck.sh
```

Ejecuta el script:

```
./setup_steamdeck.sh
```
