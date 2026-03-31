# 📊 Salidas Reales del Cluster — 27/02/2026

## docker node ls

```
ID                            HOSTNAME         STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
379nw2cfk110bswrl1bnnw22b *   swarm-manager    Ready     Active         Leader           29.2.1
rweytnq52zckj0d9dl6uw866s     swarm-worker01   Ready     Active                          29.2.1
c5axta20cnj9x6l3g7g6komww     swarm-worker02   Ready     Active                          29.2.1
```

---

## docker info | grep -A 10 "Swarm:"

```
 Swarm: active
  NodeID: 379nw2cfk110bswrl1bnnw22b
  Is Manager: true
  ClusterID: e64dumvxtgda8nuhyagy6fcxg
  Managers: 1
  Nodes: 3
  Data Path Port: 4789
  Orchestration:
   Task History Retention Limit: 5
  Raft:
   Snapshot Interval: 10000
```

---

## docker node inspect swarm-worker01 --pretty

```
ID:                     rweytnq52zckj0d9dl6uw866s
Hostname:               swarm-worker01
Joined at:              2026-02-27 22:21:23.2554298 +0000 utc
Status:
 State:                 Ready
 Availability:          Active
 Address:               192.168.1.104
Platform:
 Operating System:      linux
 Architecture:          x86_64
Resources:
 CPUs:                  2
 Memory:                1.39GiB
Engine Version:         29.2.1
```

---

## docker service ls (con web-test desplegado)

```
ID             NAME       MODE         REPLICAS   IMAGE          PORTS
xoudxghke378   web-test   replicated   3/3        nginx:alpine   *:8080->80/tcp
```

---

## docker service ps web-test (3 réplicas)

```
ID             NAME         IMAGE          NODE             DESIRED STATE   CURRENT STATE
rkeonvzexagz   web-test.1   nginx:alpine   swarm-worker02   Running         Running 2 minutes ago
muxx72xorpcx   web-test.2   nginx:alpine   swarm-manager    Running         Running 2 minutes ago
xu8s3um9dpj8   web-test.3   nginx:alpine   swarm-worker01   Running         Running 2 minutes ago
```

---

## docker service ps web-test (escalado a 6 réplicas)

```
ID             NAME         IMAGE          NODE             DESIRED STATE   CURRENT STATE
rkeonvzexagz   web-test.1   nginx:alpine   swarm-worker02   Running         Running 13 minutes ago
muxx72xorpcx   web-test.2   nginx:alpine   swarm-manager    Running         Running 14 minutes ago
xu8s3um9dpj8   web-test.3   nginx:alpine   swarm-worker01   Running         Running 13 minutes ago
i99megb2z97h   web-test.4   nginx:alpine   swarm-manager    Running         Running 5 seconds ago
mpqmwqnlebf2   web-test.5   nginx:alpine   swarm-worker01   Running         Running 5 seconds ago
56vpw6i0nfq7   web-test.6   nginx:alpine   swarm-worker02   Running         Running 5 seconds ago
```

---

## docker network ls (tras crear production-net)

```
NETWORK ID     NAME              DRIVER    SCOPE
7605b03cc97f   bridge            bridge    local
1c50e50e3512   docker_gwbridge   bridge    local
33d153983938   host              host      local
x97at19c5jzh   ingress           overlay   swarm
8923ecb748ef   none              null      local
             production-net    overlay   swarm
```

---

## Labels verificados (jq)

```json
swarm-manager:  { "role": "manager", "zone": "az1" }
swarm-worker01: { "role": "worker",  "zone": "az2" }
swarm-worker02: { "role": "worker",  "zone": "az3" }
```
