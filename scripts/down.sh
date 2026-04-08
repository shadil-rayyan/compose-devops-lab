#!/bin/bash

echo "🛑 Stopping DevOps Lab..."

# Stop Traefik
if [ -f infra/traefik/docker-compose.yml ]; then
    echo "🌐 Stopping Traefik..."
    docker compose -f infra/traefik/docker-compose.yml down
fi

# Find all docker-compose files in apps/
echo "🔍 Discovering services to stop..."
mapfile -t COMPOSE_FILES < <(find apps -name "docker-compose.yml" | sort -r)

for file in "${COMPOSE_FILES[@]}"; do
    echo "▶️ Stopping $(dirname $file)..."
    docker compose -f "$file" down || true
done

echo "✅ All services stopped!"