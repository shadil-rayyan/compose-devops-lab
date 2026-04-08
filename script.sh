#!/bin/bash
set -e

echo "🚀 Bootstrapping DevOps Lab configs..."

# =========================
# LOGGING: Loki + Promtail
# =========================
mkdir -p apps/logging/loki/config
mkdir -p apps/logging/loki/promtail

[ ! -f apps/logging/loki/config/loki.yaml ] && cat <<EOF > apps/logging/loki/config/loki.yaml
auth_enabled: false
server:
  http_listen_port: 3100
common:
  path_prefix: /tmp/loki
  storage:
    filesystem:
      chunks_directory: /tmp/loki/chunks
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory
schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h
EOF

[ ! -f apps/logging/loki/promtail/config.yaml ] && cat <<EOF > apps/logging/loki/promtail/config.yaml
server:
  http_listen_port: 9080
positions:
  filename: /tmp/positions.yaml
clients:
  - url: http://loki:3100/loki/api/v1/push
scrape_configs:
  - job_name: system
    static_configs:
      - targets: [localhost]
        labels:
          job: varlogs
          __path__: /var/log/*.log
EOF

# =========================
# MONITORING: Prometheus
# =========================
mkdir -p apps/monitoring/prometheus

[ ! -f apps/monitoring/prometheus/prometheus.yml ] && cat <<EOF > apps/monitoring/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ["localhost:9090"]
EOF

# =========================
# ALERTMANAGER
# =========================
mkdir -p apps/monitoring/alertmanager

[ ! -f apps/monitoring/alertmanager/alertmanager.yml ] && cat <<EOF > apps/monitoring/alertmanager/alertmanager.yml
route:
  receiver: default

receivers:
  - name: default
EOF

# =========================
# ELK: Logstash pipeline
# =========================
mkdir -p apps/search/elk-stack/logstash/pipeline

[ ! -f apps/search/elk-stack/logstash/pipeline/logstash.conf ] && cat <<EOF > apps/search/elk-stack/logstash/pipeline/logstash.conf
input { stdin {} }

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
  }
  stdout { codec => rubydebug }
}
EOF

# =========================
# OPENTELEMETRY
# =========================
mkdir -p apps/tracing/otel

[ ! -f apps/tracing/otel/config.yaml ] && cat <<EOF > apps/tracing/otel/config.yaml
receivers:
  otlp:
    protocols:
      grpc:
      http:

exporters:
  logging:

service:
  pipelines:
    traces:
      receivers: [otlp]
      exporters: [logging]
EOF

echo "✅ Bootstrap complete!"