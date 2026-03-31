#!/bin/bash
# =============================================================
#  04-firewall.sh
#  Configura reglas UFW para Docker Swarm
#  Ejecutar en: TODOS los nodos
# =============================================================

echo "=================================================="
echo "   Configurando Firewall (UFW)"
echo "=================================================="

# SSH — imprescindible para no perder acceso
sudo ufw allow 22/tcp comment 'SSH'

# HTTP / HTTPS para servicios desplegados
sudo ufw allow 80/tcp comment 'HTTP'
sudo ufw allow 443/tcp comment 'HTTPS'

# Puerto para servicios de prueba
sudo ufw allow 8080/tcp comment 'Servicios test'

# Portainer
sudo ufw allow 9000/tcp comment 'Portainer UI'
sudo ufw allow 9443/tcp comment 'Portainer HTTPS'

# Swarm — comunicación manager-worker
sudo ufw allow 2377/tcp comment 'Docker Swarm management'

# Gossip protocol entre nodos (TCP y UDP)
sudo ufw allow 7946/tcp comment 'Docker Swarm node communication TCP'
sudo ufw allow 7946/udp comment 'Docker Swarm node communication UDP'

# Overlay network — tráfico entre containers
sudo ufw allow 4789/udp comment 'Docker overlay network'

# Activar UFW
sudo ufw --force enable

echo ""
echo " Firewall configurado. Estado actual:"
sudo ufw status verbose
