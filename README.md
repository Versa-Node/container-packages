# VersaNode Container Packages (VNCP)

[![CI](https://github.com/Versa-Node/container-packages/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/Versa-Node/container-packages/actions/workflows/ci.yml)
[![Publish to GHCR](https://github.com/Versa-Node/container-packages/actions/workflows/ghcr.yml/badge.svg?branch=main)](https://github.com/Versa-Node/container-packages/actions/workflows/ghcr.yml)
![Platforms](https://img.shields.io/badge/platforms-arm64%20%7C%20amd64-blue)
![License](https://img.shields.io/badge/license-MIT-informational)
![Last commit](https://img.shields.io/github/last-commit/Versa-Node/container-packages)
![Contributors](https://img.shields.io/github/contributors/Versa-Node/container-packages)

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

Each package ships **`vncp.config.yaml`**, declaring user-settable parameters with **type**, **description**, defaults, and validation hints.

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


- **Embed `vncp.config.yaml` inside each image** at `/usr/share/versanode/vncp.config.yaml`
- Adds labels:
  - `io.versanode.vncp.config.path`
  - `io.versanode.vncp.config.inline` (gz+base64 of the YAML)
  - `io.versanode.vncp.config.sha256`
  - `io.versanode.vncp.config.url`
  - `org.opencontainers.image.documentation`

---


## 5) Where to Find Published Packages

All published container packages are visible under the org’s packages:  
https://github.com/orgs/Versa-Node/packages

---

## 6) Quick Start

```bash
git clone https://github.com/Versa-Node/container-packages.git
cd container-packages

# One-time: create the shared network used by all services
bash tools/ensure-network.sh

# See available packages
ls -1 packages
```

Run a package (after creating a `.env` in that package folder):

```bash
cd packages/vncp-mosquitto
docker compose up -d
```

Services on the `versanode` network can reach each other by service name (e.g., a flow in Node-RED can connect to `vncp-postgresql:5432`).

---

## 7) CI/CD (GitHub Actions)

This repo has two workflows:

- **CI:** `.github/workflows/ci.yml` — validates package metadata and `docker-compose.yml` files.
- **Publish:** `.github/workflows/ghcr.yml` — builds multi-arch images and publishes to GHCR with tags: `latest`, `<short-sha>`, and `versanode-controller-package`.

To publish from your fork instead of the org, ensure:
- Workflow permissions include `packages: write`.
- You’re pushing to **your** namespace, or you use a PAT with SSO enabled to the org.

---

## 8) Contributing a New Container

We ❤️ community packages. Follow this checklist:

### A) Scaffold
1. Create a new folder from the template:
   ```bash
   cp -r packages/vncp-template packages/vncp-<your-app>
   ```

### B) Fill out the metadata
2. Edit `packages/vncp-<your-app>/package.yaml`:
   - `name`: `vncp-<your-app>`
   - `description`: short one-liner
   - `upstream.image`: upstream image (e.g., `eclipse-mosquitto:2`)
   - `arch`: leave default unless you know otherwise
   - `maintainers`: add yourself

3. Write a minimal `Dockerfile`:
   - Prefer **FROM upstream** + labels (don’t rebuild the world).
   - Add OCI labels; keep image small.

4. Write `docker-compose.yml`:
   - Include `env_file: ./.env`
   - Attach to the shared network:
     ```yaml
     networks: [versanode]
     ```
   - Map ports/volumes as needed.
   - Add a **healthcheck**.

### C) Define user parameters
5. Create `vncp.config.yaml`:
   - Include **typed** parameters with **descriptions** and sensible **defaults**.
   - Add `mappings.env` (keys to write into `.env`).
   - If you require files, add `mappings.files` and provide templates in `templates/`.

### D) Test locally
6. On your host:
   ```bash
   bash tools/ensure-network.sh
   # create .env from your vncp.config.yaml values
   docker compose -f packages/vncp-<your-app>/docker-compose.yml config >/dev/null
   ```
   Optionally build & run if your Dockerfile is custom.

### E) Open a PR
7. Include:
   - A short package README (what it does, ports, volumes, gotchas).
   - Example `.env` snippet.
   - Any special capabilities/devices needed.
   - CI should pass (`ci.yml`).

We’ll review, suggest tweaks if needed, and merge. 🎉

---

## 9) Security & Secrets

- Mark sensitive parameters with `type: password` and `secret: true` in `vncp.config.yaml`.
- Store secrets in `.env` with strict file permissions, or use a secrets manager.
- If publishing publicly, avoid embedding secrets in `Dockerfile` layers.

---

## 10) Troubleshooting

- **“repository must be lowercase”**: reference `ghcr.io/versa-node/...` (lowercase).
- **Services can’t see each other**: ensure the external **`versanode`** network exists and services attach to it.
- **Images don’t show under the org**: make sure your workflow has `packages: write` and is pushing to the correct namespace.

---

## 11) License

MIT © VersaNode Community
