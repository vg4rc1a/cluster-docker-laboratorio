#!/bin/bash
# =============================================================
#  08-test-service.sh
#  Despliega y valida un servicio Nginx distribuido
#  Ejecutar en: swarm-manager ÚNICAMENTE
# =============================================================

echo "=================================================="
echo "   Servicio de Prueba — Nginx en Swarm"
echo "=================================================="

# Crear red overlay cifrada de producción
echo "📡 Creando red overlay 'production-net'..."
docker network create \
    --driver overlay \
    --opt encrypted \
    --attachable \
    production-net 2>/dev/null || echo "   (Red ya existe)"

echo ""
echo "🚀 Desplegando servicio web-test (3 réplicas)..."
docker service create \
    --name web-test \
    --replicas 3 \
    --publish published=8080,target=80 \
    nginx:alpine

echo ""
echo "⏳ Esperando que el servicio esté listo..."
sleep 5

echo ""
echo " Servicios activos:"
docker service ls

echo ""
echo " Distribución en nodos:"
docker service ps web-test

echo ""
echo " Probando balanceo de carga (6 peticiones):"
for i in {1..6}; do
    curl -s http://192.168.1.101:8080 | grep -o "Welcome to nginx" && echo " ← request $i"
done

echo ""
echo " Escalando a 6 réplicas..."
docker service scale web-test=6

echo ""
echo " Esperando convergencia..."
sleep 8

echo ""
echo " Distribución final (6 réplicas):"
docker service ps web-test

echo ""
echo "=================================================="
echo " Prueba completada."
echo ""
echo "Para eliminar el servicio de prueba:"
echo "  docker service rm web-test"
echo "=================================================="
