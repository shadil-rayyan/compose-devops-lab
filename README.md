# 🚀 DevOps Lab

A **production-like local DevOps environment** for learning and experimenting with modern tools — all running on your machine with **clean domain-based access** and **zero port conflicts**.

---

## ✨ Features

* 🧩 Modular architecture (each service isolated)
* 🌐 Domain-based routing (`*.test`) via Traefik
* 🔀 Dynamic ports (no conflicts ever)
* 📴 No auto-restart (full control over services)
* ⚡ One-command startup
* 📦 Real-world DevOps stack

---

## 🛠️ Tech Stack

* Docker – container runtime
* Traefik – reverse proxy & routing
* Jenkins – CI/CD automation
* Prometheus – monitoring
* Grafana – dashboards
* Backstage – developer portal

---

## 📁 Project Structure

```
devops-lab/
├── apps/
│   ├── jenkins/
│   ├── prometheus/
│   ├── grafana/
│   └── backstage/
│
├── infra/
│   └── traefik/
│
├── scripts/
│   ├── setup-hosts.sh
│   ├── up.sh
│   └── down.sh
│
├── Makefile
└── README.md
```

---

## ⚡ Quick Start

### 1. Clone the repo

```
git clone <your-repo-url>
cd devops-lab
```

---

### 2. Start everything

```
chmod +x scripts/setup-hosts.sh
chmod +x scripts/up.sh
chmod +x scripts/down.sh
make up
```

This will:

* Create required Docker network
* Configure local domains
* Start all services

---

### 3. Access services

Open in your browser:

* http://jenkins.test
* http://grafana.test
* http://prometheus.test
* http://backstage.test

---

## 🛑 Stop everything

```
make down
```

---

## 🌐 Local DNS Setup

Domains are mapped using `/etc/hosts`.

Example:

```
127.0.0.1 jenkins.test grafana.test prometheus.test backstage.test
```

The setup script will handle this automatically.

---

## 🧠 How It Works

* Traefik listens on port **80**
* Routes traffic based on domain names
* Each service runs inside Docker without exposing ports
* Communication happens via a shared Docker network


[how to add new service](new-setup.md)
---

## ⚠️ Important Notes

### 🔐 Security

* Docker socket is mounted for CI/CD use
* This setup is **for local development only**

---

### 🔄 No Auto Restart

* Containers use `restart: "no"`
* Services will **NOT restart automatically**
* You must start them manually

---

### 🌐 Domain Issues

If `.test` domains don’t resolve:

* Check `/etc/hosts`
* Restart your browser

---

## 🧪 Troubleshooting

### Port 80 already in use

```
sudo lsof -i :80
```

Stop conflicting service (e.g., Apache/Nginx)

---

### Services not accessible

* Check if Traefik is running:

```
docker ps
```

* Check logs:

```
docker logs traefik
```

---

### Reset everything

```
make down
docker system prune -a
```

---

## 📚 Learning Goals

This lab helps you practice:

* CI/CD pipelines with Jenkins
* Monitoring with Prometheus
* Visualization with Grafana
* Platform engineering with Backstage
* Reverse proxy & routing

---

## 🚀 Roadmap

* [ ] HTTPS (local SSL)
* [ ] Prebuilt Grafana dashboards
* [ ] Sample CI/CD pipelines
* [ ] Real Backstage app setup
* [ ] Kubernetes version

---

## 🤝 Contributing

Contributions are welcome!

* Add new services
* Improve docs
* Fix bugs
* Share learning examples

---

## ⭐ Support

If this project helps you:

👉 Star the repo
👉 Share with others

---

## 🧠 Philosophy

> Learn DevOps by building real systems — not just reading theory.

---

## 📄 License

MIT License
