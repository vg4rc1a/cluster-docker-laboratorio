#!/bin/bash
# =============================================================
#  06-join-worker.sh
#  Une un nodo Worker al Docker Swarm
#  Ejecutar en: swarm-worker01 y swarm-worker02
#
#  Uso: bash 06-join-worker.sh <TOKEN> [MANAGER_IP]
#
#  Token del laboratorio (27/02/2026):
#  SWMTKN-1-2ucfp5fnwj3p7z1e2kqwxyjv2ii2vs9fdv4942y7wjof4bylx0-bepld33p0368c0f8ytpfb48sh
# =============================================================

TOKEN=$1
MANAGER_IP=${2:-"192.168.1.101"}
MANAGER_PORT="2377"

if [ -z "$TOKEN" ]; then
  echo " Error: Debes proporcionar el token del Swarm."
  echo ""
  echo "   Uso: $0 <SWARM_TOKEN> [MANAGER_IP]"
  echo ""
  echo "   Obtén el token desde el Manager con:"
  echo "   docker swarm join-token worker"
  exit 1
fi

echo "=================================================="
echo "   Uniendo nodo Worker al Swarm"
echo "  Manager: $MANAGER_IP:$MANAGER_PORT"
echo "=================================================="

docker swarm join \
    --token "$TOKEN" \
    "$MANAGER_IP:$MANAGER_PORT"

if [ $? -eq 0 ]; then
  echo ""
  echo " Este nodo se unió al Swarm exitosamente como Worker."
else
  echo ""
  echo " Error al unirse al Swarm."
  echo "   Verifica el token y la conectividad con el Manager."
fi
