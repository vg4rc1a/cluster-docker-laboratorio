#!/bin/bash
# =============================================================
#  03-install-docker.sh
#  Instala Docker Engine en Ubuntu Server 22.04
#  Ejecutar en: TODOS los nodos (manager y workers)
# =============================================================

echo "=================================================="
echo "   Instalando Docker Engine"
echo "=================================================="

# Configurar /etc/hosts del cluster
echo ""
echo " Configurando /etc/hosts..."
sudo tee -a /etc/hosts <<EOF

# Docker Swarm Cluster
192.168.1.101  swarm-manager
192.168.1.104  swarm-worker01
192.168.1.105  swarm-worker02
EOF

# Verificar conectividad
echo ""
echo " Verificando conectividad..."
ping -c 3 swarm-manager
ping -c 3 swarm-worker01
ping -c 3 swarm-worker02

# Desinstalar versiones antiguas
echo ""
echo "  Eliminando versiones antiguas..."
sudo apt remove -y docker.io docker-compose docker-compose-v2 \
    docker-doc podman-docker containerd runc 2>/dev/null || true

# Instalar dependencias
echo ""
echo " Instalando dependencias..."
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    apt-transport-https \
    net-tools \
    ufw

# Agregar GPG key oficial de Docker
echo ""
echo " Agregando clave GPG de Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Agregar repositorio oficial
echo ""
echo " Agregando repositorio Docker..."
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Instalar Docker Engine
echo ""
echo "  Instalando Docker Engine..."
sudo apt update
sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Habilitar e iniciar Docker
echo ""
echo " Habilitando Docker al inicio..."
sudo systemctl enable docker
sudo systemctl start docker

# Agregar usuario al grupo docker
echo ""
echo " Agregando usuario al grupo docker..."
sudo usermod -aG docker $USER

# Aplicar daemon.json
# NOTA: live-restore=false es OBLIGATORIO para Docker Swarm
echo ""
echo "  Configurando daemon.json..."
sudo tee /etc/docker/daemon.json <<'EOF'
{
  "live-restore": false,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl restart docker
sudo systemctl status docker --no-pager

echo ""
echo " Docker instalado correctamente."
echo ""
docker --version
docker compose version
echo ""
echo "  Cierra sesión y vuelve a entrar para aplicar el grupo docker."
echo "    Luego verifica con: docker run hello-world"
