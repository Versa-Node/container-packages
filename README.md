# VersaNode Container Packages (VNCP)

Containers for **VersaNode** (RPi CM5 **arm64** first-class; **amd64** supported).  
Every package is prefixed **`vncp-`** (*VersaNode Controller Package*).

---

## 1) Image Registry & Naming

- **Registry (GHCR):**  
  `ghcr.io/versa-node/vncp-<package>:<tag>`  
  > ℹ️ GHCR namespaces are **lowercase**. If your GitHub org is `Versa-Node`, the path is `ghcr.io/versa-node/...`.

- **Standard tags**
  - `latest` — current build from `main`
  - `<short-sha>` — immutable build traceability
  - `versanode-controller-package` — stable, static tag

**Examples**
```bash
docker pull ghcr.io/versa-node/vncp-mosquitto:latest
docker pull ghcr.io/versa-node/vncp-nodered:versanode-controller-package
```

---

## 2) Network Model

All VNCP services join a shared external Docker network **`versanode`** so they can discover each other by service name.

Create it once per host:
```bash
docker network create versanode 2>/dev/null || true
# or: bash tools/ensure-network.sh
```

Compose files already attach each service to this network.

---

## 3) Runtime Configuration Flow

Each package ships **`vncp.config.yaml`**, declaring user-settable parameters (with **type**, **description**, defaults, and validation hints).

**Workflow**
1. Your cockpit (or you) collects values from the user.
2. On the **Docker host**, you render:
   - a `.env` file (key=value pairs)
   - any optional config files from templates (if a package provides them)
3. Run the service. Each `docker-compose.yml` includes:
   ```yaml
   env_file: ./.env
   ```
   so runtime config is loaded automatically.

**Example `.env` (vncp-mosquitto)**
```env
MQTT_PORT=1883
WS_ENABLE=true
WS_PORT=9001
ALLOW_ANONYMOUS=false
MQTT_USER=habibi
MQTT_PASSWORD=supersecret
```

---

## 4) `vncp.config.yaml` – Parameter Schema (Quick Reference)

Each entry in `parameters:` can include:

- `key` — environment key (e.g., `MQTT_PORT`)
- `label` — friendly name for UIs
- `type` — one of: `string`, `password`, `int`, `bool`, `enum`, `path`, `port`
- `description` — what the parameter controls
- `default` — default value
- `required` — `true|false`
- `enum` — allowed values (when `type: enum`)
- `min` / `max` — numeric bounds (for `int`/`port`)
- `pattern` — regex validation (for `string`)
- `secret` — hint to store securely (`true|false`)

**Mappings**
- `mappings.env` — list of keys to write into `.env`
- `mappings.files` — optional file templates (your tool renders on host)

---

## 5) Architecture & Platforms

- **arm64**: first-class (RPi CM5 / VersaNode hardware)
- **amd64**: supported in multi-arch images

---

## 6) Where to Find Published Packages

All published container packages are visible under the org’s packages:  
https://github.com/orgs/Versa-Node/packages

---

## 7) Running a Package (Example)

```bash
# After creating .env in the package directory:
cd packages/vncp-mosquitto
docker compose up -d
```

Services on the `versanode` network can reach each other by service name (e.g., a flow in Node-RED can connect to `vncp-postgresql:5432`).

---

## 8) Security & Secrets

- Mark sensitive parameters with `type: password` and `secret: true` in `vncp.config.yaml`.
- Store secrets in `.env` using best practices for your host (permissions, secret managers).
- Set GHCR package **visibility** to **Public** if you want unauthenticated pulls.

---

## 9) Troubleshooting

- **“repository must be lowercase”**: ensure you reference `ghcr.io/versa-node/...` (lowercase).
- **Can’t see/resolve other services**: make sure the **`versanode`** network exists and the service attaches to it.
- **Images not appearing in org**: verify your CI pushes to the org’s namespace and your workflow has `packages: write` permission.

---
