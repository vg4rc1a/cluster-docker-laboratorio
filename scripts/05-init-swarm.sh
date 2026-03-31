#!/bin/bash
# =============================================================
#  05-init-swarm.sh
#  Inicializa el Docker Swarm
#  Ejecutar en: swarm-manager (192.168.1.101) ÚNICAMENTE
#
#  Token real generado el 27/02/2026:
#  SWMTKN-1-2ucfp5fnwj3p7z1e2kqwxyjv2ii2vs9fdv4942y7wjof4bylx0-bepld33p0368c0f8ytpfb48sh
# =============================================================

MANAGER_IP="192.168.1.101"

echo "=================================================="
echo "   Inicializando Docker Swarm"
echo "  Manager IP: $MANAGER_IP"
echo "=================================================="

docker swarm init --advertise-addr $MANAGER_IP

echo ""
echo "=================================================="
echo "   Tokens para unir nodos al Swarm:"
echo "=================================================="
echo ""
echo " Token para WORKERS:"
docker swarm join-token worker
echo ""
echo " Token para MANAGERS adicionales:"
docker swarm join-token manager
echo ""
echo " Estado del cluster:"
docker node ls

# Instalar jq (necesario para inspeccionar labels)
echo ""
echo " Instalando jq..."
sudo apt install -y jq
