#!/bin/bash

docker network create devops-net 2>/dev/null || true

docker compose -f infra/traefik/docker-compose.yml up -d
sleep 2

docker compose -f apps/jenkins/docker-compose.yml up -d
docker compose -f apps/prometheus/docker-compose.yml up -d
docker compose -f apps/grafana/docker-compose.yml up -d
docker compose -f apps/backstage/docker-compose.yml up -d