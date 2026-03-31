# 📖 Guía Completa de Instalación

## Requisitos Previos

- VirtualBox o VMware con las VMs creadas
- pfSense configurado: WAN `192.168.1.88` / LAN `192.168.1.1`
- Ubuntu Server 22.04 instalado en los 3 nodos
- Acceso SSH o consola a cada nodo

---

## Paso 1 — Teclado y actualizaciones (todos los nodos)

```bash
sudo dpkg-reconfigure keyboard-configuration
sudo service keyboard-setup restart
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
```

---

## Paso 2 — IPs estáticas con Netplan

### swarm-manager (192.168.1.101)
```bash
sudo hostnamectl set-hostname swarm-manager
sudo nano /etc/netplan/00-installer-config.yaml
```
Pegar el contenido de `configs/netplan/manager.yaml`, luego:
```bash
sudo netplan apply
sudo systemctl restart systemd-networkd
ip a | grep inet
```

### swarm-worker01 (192.168.1.104)
```bash
sudo hostnamectl set-hostname swarm-worker01
sudo nano /etc/netplan/00-installer-config.yaml
```
Pegar `configs/netplan/worker01.yaml`, luego aplicar igual.

### swarm-worker02 (192.168.1.105)
```bash
sudo hostnamectl set-hostname swarm-worker02
sudo nano /etc/netplan/00-installer-config.yaml
```
Pegar `configs/netplan/worker02.yaml`, luego aplicar igual.

---

## Paso 3 — /etc/hosts y conectividad (todos los nodos)

```bash
sudo tee -a /etc/hosts <<EOF

# Docker Swarm Cluster
192.168.1.101  swarm-manager
192.168.1.104  swarm-worker01
192.168.1.105  swarm-worker02
EOF

# Verificar
ping -c 3 swarm-manager
ping -c 3 swarm-worker01
ping -c 3 swarm-worker02
```

---

## Paso 4 — Instalar Docker (todos los nodos)

```bash
bash scripts/03-install-docker.sh
```

> ⚠️ **Importante:** `live-restore` debe ser `false` en Swarm Mode.  
> Ver `configs/daemon.json` para la configuración correcta.

Verificar:
```bash
docker --version         # Docker version 29.2.1
docker compose version
docker run hello-world
```

---

## Paso 5 — Firewall UFW (todos los nodos)

```bash
bash scripts/04-firewall.sh
```

Puertos habilitados: `22, 80, 443, 2377/tcp, 7946/tcp+udp, 4789/udp, 8080, 9000, 9443`

---

## Paso 6 — Inicializar el Swarm (solo swarm-manager)

```bash
docker swarm init --advertise-addr 192.168.1.101
```

Salida real del laboratorio:
```
Swarm initialized: current node (379nw2cfk110bswrl1bnnw22b) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-2ucfp5fnwj3p7z1e2kqwxyjv2ii2vs9fdv4942y7wjof4bylx0-bepld33p0368c0f8ytpfb48sh 192.168.1.101:2377
```

Recuperar tokens cuando los necesites:
```bash
docker swarm join-token worker    # token para workers
docker swarm join-token manager   # token para managers adicionales
```

---

## Paso 7 — Unir Workers al Swarm

### En swarm-worker01 y swarm-worker02:
```bash
docker swarm join \
    --token SWMTKN-1-2ucfp5fnwj3p7z1e2kqwxyjv2ii2vs9fdv4942y7wjof4bylx0-bepld33p0368c0f8ytpfb48sh \
    192.168.1.101:2377
```

Salida esperada:
```
This node joined a swarm as a worker.
```

Verificar desde el manager:
```bash
docker node ls
```
```
ID                            HOSTNAME         STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
379nw2cfk110bswrl1bnnw22b *   swarm-manager    Ready     Active         Leader           29.2.1
rweytnq52zckj0d9dl6uw866s     swarm-worker01   Ready     Active                          29.2.1
c5axta20cnj9x6l3g7g6komww     swarm-worker02   Ready     Active                          29.2.1
```

---

## Paso 8 — Labels de Nodos (solo swarm-manager)

```bash
sudo apt install -y jq
bash scripts/07-labels.sh
```

Labels asignados:

| Nodo           | zone | role    |
|----------------|------|---------|
| swarm-manager  | az1  | manager |
| swarm-worker01 | az2  | worker  |
| swarm-worker02 | az3  | worker  |

---

## Paso 9 — Red Overlay + Servicio de Prueba

```bash
bash stacks/production-net.sh
bash scripts/08-test-service.sh
```

El servicio Nginx se distribuye automáticamente entre los 3 nodos:
```
web-test.1   nginx:alpine   swarm-worker02   Running
web-test.2   nginx:alpine   swarm-manager    Running
web-test.3   nginx:alpine   swarm-worker01   Running
```

Prueba de balanceo:
```bash
for i in {1..6}; do
    curl -s http://192.168.1.101:8080 | grep -o "Welcome to nginx"
done
```

Eliminar servicio de prueba:
```bash
docker service rm web-test
```
