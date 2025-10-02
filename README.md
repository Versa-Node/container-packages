# VersaNode Container Packages (VNCP)

Community-driven containers for **VersaNode** (RPi CM5, `arm64`).  
All package names are prefixed with `vncp-` (VersaNode Controller Package).

**Images on GHCR:** `ghcr.io/<your-org>/vncp-<package>:latest`

**Shared network:** All services join an external Docker network named `versanode` so they can reach each other by service name.

**Runtime config:** Each package defines parameters in `vncp.config.yaml` (with `type`, `description`, defaults, and validation hints).  
You (or your cockpit tool) render a `.env` and optional files **on the Docker host**, and the compose files load them via `env_file: .env`.

## Quick start
```bash
git clone https://github.com/<your-org>/container-packages.git
cd container-packages
bash tools/ensure-network.sh         # create shared 'versanode' network
make list                            # list packages
```

To run a package (after you've created a `.env` in that package folder):
```bash
cd packages/vncp-mosquitto
docker compose up -d
```

## Repo layout
- `packages/` — one folder per `vncp-*` package
- `docs/` — cockpit config spec & notes
- `tools/` — helpers (validate, ensure network)
- `.github/workflows` — CI for lint+publish (GHCR)
