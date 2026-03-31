#!/bin/bash
# =============================================================
#  production-net.sh
#  Crea la red overlay cifrada para servicios en producción
#  Ejecutar en: swarm-manager ÚNICAMENTE
# =============================================================

echo "=================================================="
echo "  📡 Creando Red Overlay de Producción"
echo "=================================================="

docker network create \
    --driver overlay \
    --opt encrypted \
    --attachable \
    production-net

echo ""
echo "🔍 Redes disponibles:"
docker network ls

echo ""
echo "✅ Red 'production-net' lista para usar en stacks."
echo ""
echo "💡 Usa esta red en tus stacks con:"
echo '   networks:'
echo '     production-net:'
echo '       external: true'
