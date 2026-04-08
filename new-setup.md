# 🧩 Managing Services (Add / Remove Apps)

This lab is designed to be **modular** — you can easily add or remove services without breaking the system.

---

# ➕ Adding a New Service

Follow these steps to integrate a new tool (e.g., Elasticsearch, Loki, Redis, etc.)

---

## 1. 📁 Create App Directory

```bash
mkdir -p apps/<service-name>
```

Example:

```bash
mkdir -p apps/loki
```

---

## 2. 🐳 Create `docker-compose.yml`

Inside `apps/<service-name>/docker-compose.yml`:

```yaml
services:
  loki:
    image: grafana/loki:latest
    command: -config.file=/etc/loki/local-config.yaml
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.loki.rule=Host(`loki.test`)"
      - "traefik.http.services.loki.loadbalancer.server.port=3100"
    networks:
      - devops-net

networks:
  devops-net:
    external: true
```

---

## 3. 🌐 Add Domain Mapping

Update `scripts/setup-hosts.sh`:

```bash
127.0.0.1 loki.test
```

Or append dynamically if your script supports it.

---

## 4. ▶️ Register in Startup Script

Edit `scripts/up.sh`:

```bash
docker compose -f apps/loki/docker-compose.yml up -d
```

---

## 5. ⛔ Register in Shutdown Script

Edit `scripts/down.sh`:

```bash
docker compose -f apps/loki/docker-compose.yml down
```

---

## 6. 🚀 Start the Service

```bash
make up
```

Then access:

```
http://loki.test
```

---

# ➖ Removing a Service

To completely remove a service:

---

## 1. 🛑 Stop the Service

```bash
docker compose -f apps/<service-name>/docker-compose.yml down
```

Or:

```bash
make down
```

---

## 2. 🧹 Remove from Scripts

### From `up.sh`

Remove:

```bash
docker compose -f apps/<service-name>/docker-compose.yml up -d
```

### From `down.sh`

Remove:

```bash
docker compose -f apps/<service-name>/docker-compose.yml down
```

---

## 3. 🌐 Remove Domain Entry

Edit `/etc/hosts` (or your script):

```bash
# remove this line
127.0.0.1 <service-name>.test
```

---

## 4. 🗑️ Delete App Directory

```bash
rm -rf apps/<service-name>
```

---

# 🔁 Restart Environment

After adding/removing services:

```bash
make down
make up
```

---

# 🧠 Best Practices

## ✅ 1. One Service = One Folder

Keep everything isolated:

```
apps/<service>/
  docker-compose.yml
  config/
```

---

## ✅ 2. Always Use Traefik Labels

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.<name>.rule=Host(`<name>.test`)"
  - "traefik.http.services.<name>.loadbalancer.server.port=<internal-port>"
```

---

## ✅ 3. Never Expose Ports

❌ Avoid:

```yaml
ports:
  - "3000:3000"
```

✅ Use Traefik instead.

---

## ✅ 4. Use Shared Network

```yaml
networks:
  - devops-net
```

---

## ✅ 5. Keep `restart: "no"`

Gives you full control during debugging.

---


# ⚠️ Common Mistakes

| Mistake             | Problem                |
| ------------------- | ---------------------- |
| Exposing ports      | Conflicts with Traefik |
| Missing network     | Service unreachable    |
| Wrong internal port | Traefik 502 error      |
| Forgot hosts entry  | Domain not resolving   |

---

# 🔥 Pro Tip (Advanced)

You can make this **fully dynamic** later:

* Auto-discover services
* Auto-update hosts file
* Use `.env` per app
* Even plug into **Backstage** as a service catalog

