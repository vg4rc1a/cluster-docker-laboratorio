#!/bin/bash
# =============================================================
#  01-keyboard-and-update.sh
#  Cambiar teclado + actualizar sistema
#  Ejecutar en: TODOS los nodos
# =============================================================

echo "  Configurando distribución de teclado..."
sudo dpkg-reconfigure keyboard-configuration
sudo service keyboard-setup restart

echo ""
echo " Actualizando sistema..."
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y

echo ""
echo " Sistema actualizado correctamente."
