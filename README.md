# VersaNode Container Packages (VNCP)

Containers for **VersaNode** (RPi CM5, `arm64` first-class; `amd64` supported).  
Every package is prefixed **`vncp-`** (*VersaNode Controller Package*).

**Registry (GHCR):** `ghcr.io/versanode/vncp-<package>:latest`  
**Shared network:** All services join the external Docker network **`versanode`** so they can reach each other by service name.  
**Runtime config:** Each package ships a **`vncp.config.yaml`** describing user-settable parameters (type, description, defaults, validation hints).  
You (or your cockpit tool) render a `.env` (and any config files) **on the Docker host**. Each `docker-compose.yml` loads `env_file: .env`.

> ℹ️ GHCR namespaces are **lowercase**. If your org is `Versa-Node`, images live under `ghcr.io/versa-node/...`.

All published container packages live here:  
https://github.com/orgs/Versa-Node/packages

---

## Quick start

```bash
git clone https://github.com/versanode/container-packages.git
cd container-packages

# One-time: create the shared network used by all services
bash tools/ensure-network.sh

# See available packages
make list
```

Run a package (after creating a `.env` in that package folder):

```bash
cd packages/vncp-mosquitto
# .env example:
# MQTT_PORT=1883
# WS_ENABLE=true
# WS_PORT=9001
# ALLOW_ANONYMOUS=false
# MQTT_USER=habibi
# MQTT_PASSWORD=supersecret
docker compose up -d
```

---

## Images & tags

- `:latest` (main branch)
- `:<short-sha>` (traceability)
- `:versanode-controller-package` (static tag)

Example pulls:
```bash
docker pull ghcr.io/versanode/vncp-mosquitto:latest
docker pull ghcr.io/versanode/vncp-mosquitto:versanode-controller-package
```

---

## Repo layout

- `packages/` — one folder per `vncp-*` package (each has `vncp.config.yaml` and `docker-compose.yml`)
- `docs/` — VNCP config spec & notes
- `tools/` — helpers (`validate.py`, `ensure-network.sh`)
- `.github/workflows/` — CI for validation & GHCR publishing
