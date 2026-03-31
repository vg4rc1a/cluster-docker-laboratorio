# 🛠️ Comandos de Administración del Swarm

Todos ejecutados desde **swarm-manager**.

---

## Gestión de Nodos

```bash
# Ver todos los nodos del cluster
docker node ls

# Inspeccionar un nodo en detalle
docker node inspect swarm-worker01 --pretty

# Ver labels de un nodo
docker node inspect swarm-worker01 --format '{{ json .Spec.Labels }}' | jq

# Promover worker a manager (Alta Disponibilidad con 3 managers)
docker node promote swarm-worker01

# Degradar manager a worker
docker node demote swarm-worker01

# Poner nodo en mantenimiento (mueve containers a otros nodos)
docker node update --availability drain swarm-worker01

# Volver nodo a producción
docker node update --availability active swarm-worker01
```

---

## Gestión de Servicios

```bash
# Listar servicios activos
docker service ls

# Ver en qué nodos corren las tareas
docker service ps <nombre_servicio>

# Escalar un servicio
docker service scale web-test=6

# Ver logs en tiempo real
docker service logs web-test --follow

# Actualizar imagen de un servicio
docker service update --image nginx:latest web-test

# Eliminar un servicio
docker service rm web-test
```

---

## Gestión de Stacks

```bash
# Desplegar un stack desde un compose file
docker stack deploy -c stack.yml <nombre_stack>

# Listar stacks desplegados
docker stack ls

# Ver servicios de un stack
docker stack services <nombre_stack>

# Ver tareas de un stack
docker stack ps <nombre_stack>

# Eliminar un stack completo
docker stack rm <nombre_stack>
```

---

## Tokens del Swarm

```bash
# Obtener token para workers
docker swarm join-token worker

# Obtener token para managers
docker swarm join-token manager

# Rotar token (invalida el anterior)
docker swarm join-token --rotate worker
```

---

## Monitoreo

```bash
# Estado general del Swarm
docker info | grep -A 15 "Swarm:"

# Uso de recursos en tiempo real
docker stats

# Ver todos los containers en todos los nodos (desde manager)
docker node ps $(docker node ls -q)

# Ver redes overlay
docker network ls --filter driver=overlay
```

---

## Solución de Problemas

```bash
# Servicio no arranca — ver errores
docker service ps <nombre> --no-trunc

# Container específico — ver logs directos
docker logs <container_id>

# Verificar conectividad entre nodos
ping -c 3 swarm-worker01
ping -c 3 swarm-worker02

# Verificar puertos del firewall
sudo ufw status verbose

# Reiniciar Docker en un nodo
sudo systemctl restart docker
```
