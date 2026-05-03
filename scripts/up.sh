#!/bin/bash

echo "🚀 Starting DevOps Lab..."

docker network create devops-net 2>/dev/null || true

# ----------------------------
# 1. Start Traefik (MANDATORY)
# ----------------------------
TRAEFIK_FILE="infra/traefik/docker-compose.yml"

if [[ -f "$TRAEFIK_FILE" ]]; then
    echo "🌐 Starting Traefik (mandatory)..."
    docker compose -f "$TRAEFIK_FILE" up -d
else
    echo "❌ Traefik compose not found! Exiting..."
    exit 1
fi

# ----------------------------
# 2. Collect services
# ----------------------------
mapfile -t SERVICES < <(find apps -name "docker-compose.yml" | sort)

if [[ ${#SERVICES[@]} -eq 0 ]]; then
    echo "⚠️ No app services found."
    exit 0
fi

OPTIONS=()

for file in "${SERVICES[@]}"; do
    service_name=$(basename "$(dirname "$file")")
    OPTIONS+=("$file" "$service_name" "off")
done

# ----------------------------
# 3. STABLE DIALOG (FIXED)
# ----------------------------
CHOICES=$(dialog --stdout --checklist \
"Select services to start (Traefik already running):" \
20 80 15 \
"${OPTIONS[@]}")

clear

# ----------------------------
# 4. Exit if nothing selected
# ----------------------------
if [[ -z "$CHOICES" ]]; then
    echo "⚠️ No services selected."
    exit 0
fi

# ----------------------------
# 5. SAFE EXECUTION (NO BUGS)
# ----------------------------
echo "▶️ Starting selected services..."

for file in $CHOICES; do
    file=$(echo "$file" | tr -d '"')

    echo "▶️ Starting $file"

    if [[ -f "$file" ]]; then
        docker compose -f "$file" up -d
    else
        echo "❌ Invalid compose path: $file"
    fi
done

echo "✅ Done! Traefik + selected services are running."