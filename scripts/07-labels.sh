#!/bin/bash
# =============================================================
#  07-labels.sh
#  Configura labels en los nodos del Swarm
#  Ejecutar en: swarm-manager ÚNICAMENTE
#
#  Los labels permiten controlar dónde se despliegan
#  los servicios (constraints de placement)
# =============================================================

echo "=================================================="
echo "    Configurando Labels de Nodos"
echo "=================================================="

# Labels por zona (disponibilidad distribuida)
echo " Asignando zonas..."
docker node update --label-add zone=az1 swarm-manager
docker node update --label-add zone=az2 swarm-worker01
docker node update --label-add zone=az3 swarm-worker02

# Labels por tipo de carga
echo ""
echo " Asignando roles..."
docker node update --label-add role=manager swarm-manager
docker node update --label-add role=worker  swarm-worker01
docker node update --label-add role=worker  swarm-worker02

# Verificar labels en cada nodo
echo ""
echo " Labels asignados:"
echo ""
echo "swarm-manager:"
docker node inspect swarm-manager  --format '{{ json .Spec.Labels }}' | jq

echo "swarm-worker01:"
docker node inspect swarm-worker01 --format '{{ json .Spec.Labels }}' | jq

echo "swarm-worker02:"
docker node inspect swarm-worker02 --format '{{ json .Spec.Labels }}' | jq

echo ""
echo "Labels configurados."
echo ""
echo " Uso en un stack (placement constraints):"
echo '   deploy:'
echo '     placement:'
echo '       constraints:'
echo '         - node.labels.zone == az1'
echo '         - node.labels.role == worker'
