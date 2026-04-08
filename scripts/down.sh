#!/bin/bash

docker compose -f apps/backstage/docker-compose.yml down
docker compose -f apps/grafana/docker-compose.yml down
docker compose -f apps/prometheus/docker-compose.yml down
docker compose -f apps/jenkins/docker-compose.yml down
docker compose -f infra/traefik/docker-compose.yml down