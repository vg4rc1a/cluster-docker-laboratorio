#!/bin/bash
# =============================================================
#  02-network-manager.sh
#  Configura IP estática en swarm-manager
#  Ejecutar en: swarm-manager
# =============================================================

echo " Configurando hostname: swarm-manager"
sudo hostnamectl set-hostname swarm-manager

echo ""
echo " Escribiendo configuración Netplan..."
sudo tee /etc/netplan/00-installer-config.yaml > /dev/null <<'EOF'
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: no
      addresses:
        - 192.168.1.101/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
EOF

echo "  Aplicando configuración..."
sudo netplan apply
sudo systemctl restart systemd-networkd

echo ""
echo " IP asignada:"
ip a | grep inet

echo ""
echo "Red configurada: 192.168.1.101/24"
