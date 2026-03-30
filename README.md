# cluster-docker-laboratorio#
# 🐳 Cluster Docker Swarm — Laboratorio

Laboratorio funcional de Docker Swarm con 3 nodos virtualizados, pfSense como gateway/firewall y Ubuntu Server 22.04.

> **Estado:** ✅ Cluster operativo — Validado el 27/02/2026  
> **Docker Engine:** 29.2.1

---

## 🗺️ Arquitectura de Red

```
Internet
    │
    ▼
┌────────────────────────────────┐
│  pfSense   WAN: 192.168.1.88   │
│            LAN: 192.168.1.1    │
└──────────────┬─────────────────┘
               │  Red LAN: 192.168.1.0/24
     ┌─────────┼──────────────────┐
     │         │                  │
     ▼         ▼                  ▼
  win10lts  swarm-manager   swarm-worker01/02
 .10        .101            .104 / .105
```

---

## 🖥️ Nodos del Cluster

| Nodo       | Hostname       | IP            | Rol              | CPU | RAM    |
|------------|----------------|---------------|------------------|-----|--------|
| Servidor 1 | swarm-manager  | 192.168.1.101 | Manager (Leader) | 2   | 1.39GB |
| Servidor 2 | swarm-worker01 | 192.168.1.104 | Worker           | 2   | 1.39GB |
| Servidor 3 | swarm-worker02 | 192.168.1.105 | Worker           | 2   | 1.39GB |
| Gateway    | pfsense        | 192.168.1.1   | Firewall/Router  | —   | —      |
| Cliente    | win10lts       | 192.168.1.10  | Administración   | —   | —      |

---

## 📁 Estructura del Repositorio

```
cluster-docker-laboratorio/
├── scripts/
│   ├── 01-keyboard-and-update.sh     # Teclado + actualizaciones
│   ├── 02-network-manager.sh         # Netplan swarm-manager
│   ├── 02-network-worker01.sh        # Netplan swarm-worker01
│   ├── 02-network-worker02.sh        # Netplan swarm-worker02
│   ├── 03-install-docker.sh          # Instalación Docker (todos los nodos)
│   ├── 04-firewall.sh                # Reglas UFW (todos los nodos)
│   ├── 05-init-swarm.sh              # Inicializar Swarm (solo Manager)
│   ├── 06-join-worker.sh             # Unir Workers al Swarm
│   ├── 07-labels.sh                  # Configurar labels de nodos
│   └── 08-test-service.sh            # Servicio de prueba Nginx
├── configs/
│   ├── daemon.json                   # Config Docker daemon (todos los nodos)
│   ├── hosts-snippet.txt             # Entradas /etc/hosts del lab
│   └── netplan/
│       ├── manager.yaml              # Netplan swarm-manager
│       ├── worker01.yaml             # Netplan swarm-worker01
│       └── worker02.yaml             # Netplan swarm-worker02
├── stacks/
│   └── production-net.sh             # Red overlay cifrada
├── docs/
│   ├── setup.md                      # Guía completa paso a paso
│   ├── swarm-output.md               # Salidas reales del cluster
│   └── admin-commands.md             # Comandos de administración
└── README.md
```

---

## 🚀 Inicio Rápido

```bash
# 1. En TODOS los nodos — Actualizar sistema
bash scripts/01-keyboard-and-update.sh

# 2. En cada nodo — Configurar IP estática
bash scripts/02-network-manager.sh   # en swarm-manager
bash scripts/02-network-worker01.sh  # en swarm-worker01
bash scripts/02-network-worker02.sh  # en swarm-worker02

# 3. En TODOS los nodos — Instalar Docker
bash scripts/03-install-docker.sh

# 4. En TODOS los nodos — Configurar Firewall
bash scripts/04-firewall.sh

# 5. Solo en swarm-manager — Inicializar Swarm
bash scripts/05-init-swarm.sh

# 6. En cada worker — Unirse al Swarm
bash scripts/06-join-worker.sh <TOKEN> 192.168.1.101

# 7. Solo en swarm-manager — Asignar labels
bash scripts/07-labels.sh

# 8. Solo en swarm-manager — Servicio de prueba
bash scripts/08-test-service.sh
```

---

## ✅ Estado Real del Cluster (27/02/2026)

```
ID                            HOSTNAME         STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
379nw2cfk110bswrl1bnnw22b *   swarm-manager    Ready     Active         Leader           29.2.1
rweytnq52zckj0d9dl6uw866s     swarm-worker01   Ready     Active                          29.2.1
c5axta20cnj9x6l3g7g6komww     swarm-worker02   Ready     Active                          29.2.1
```

---

## 🔌 Puertos Habilitados (UFW)

| Puerto   | Proto  | Uso                              |
|----------|--------|----------------------------------|
| 22/tcp   | TCP    | SSH                              |
| 80/tcp   | TCP    | HTTP servicios                   |
| 443/tcp  | TCP    | HTTPS servicios                  |
| 2377/tcp | TCP    | Docker Swarm management          |
| 7946     | TCP/UDP| Gossip protocol entre nodos      |
| 4789/udp | UDP    | Overlay network (containers)     |
| 8080/tcp | TCP    | Servicios de prueba              |
