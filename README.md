# container-packages

Community-driven repository of containerized packages for **VersaNode** (a mini-server built around Raspberry Pi Compute Module 5, `arm64`).  
Packages are simple, composable building blocks (e.g., MQTT broker/client, NAS, Home Assistant, OpenEMS, Node-RED) that can be mixed into your stack.

> **Architectures:** Optimized for `linux/arm64` (CM5). Most images also run on `linux/amd64`.  
> **Orchestration:** Docker Compose by default. Kubernetes manifests can be contributed later.

## Quick start

**Images on GHCR:** `ghcr.io/versanode/<package>:latest`

```bash
git clone https://github.com/YOUR-ORG/container-packages.git
cd container-packages
make bootstrap           # installs pre-commit hooks, basic checks
make list                # list available packages
make compose-example     # prints a multi-service compose example
```

To bring up a single package:

```bash
cd packages/mosquitto
docker compose -f docker-compose.example.yml up -d
```

## Repo layout

- `packages/` — one folder per package
- `docs/` — how-tos, spec, and VersaNode notes
- `tools/` — helper scripts (build, test, new package scaffolding)
- `.github/workflows` — CI for linting and optional cross-arch builds

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) and the [package spec](docs/package-spec.md).
Start with the ready-to-copy [template](packages/template).


## Docker Hub

All packages are published to Docker Hub under `ghcr.io/versanode/<package>` (arm64/amd64).  
Set GitHub repo secrets `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` to enable CI pushes.

Example:
```bash
docker pull ghcr.io/versanode/mosquitto:latest
docker run -p 1883:1883 ghcr.io/versanode/mosquitto:latest
```


## GitHub Container Registry (GHCR)
These container packages are all prefixed with `vncp-` - VersaNode Container Package.
All packages are published to GHCR under `ghcr.io/versanode/<package>` (arm64/amd64). A full list of the published packages can 
be found under the our organization here `https://github.com/orgs/Versa-Node/packages`

**Setup CI:** In your GitHub repo → Settings → Secrets and variables → Actions
- `GHCR_TOKEN` — a GitHub Personal Access Token (classic) with `write:packages` scope (or use PAT fine-grained with Packages: Read/Write).

**Pull examples:**
```bash
docker pull ghcr.io/versanode/mosquitto:latest
docker pull ghcr.io/versanode/nodered:latest
docker pull ghcr.io/versanode/home-assistant:latest
docker pull ghcr.io/versanode/openems:latest
docker pull ghcr.io/versanode/nas-samba:latest
```
