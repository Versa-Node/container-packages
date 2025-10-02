# vncp-nodered

**Node-RED** low-code flow editor packaged for VersaNode.

- **Image:** `ghcr.io/versa-node/vncp-nodered:latest`
- **Port (default):** `1880`
- **Volume:** `./data`
- **Network:** `versanode`

## Configure

Define parameters in `vncp.config.yaml` and generate a `.env` on the host.

**Keys**
- `NODERED_PORT` *(port, default 1880)* — host port for the editor/UI
- `TZ` *(string, default UTC)* — container timezone
- `ENABLE_PROJECTS` *(bool, default false)* — enable Projects

**Example `.env`**
```env
NODERED_PORT=1880
TZ=Europe/Amsterdam
ENABLE_PROJECTS=false
```

> Projects mode may require a custom `settings.js`. Provide it via a bind mount in `./data` if needed.

## Run
```bash
bash ../../tools/ensure-network.sh
docker compose up -d
```

Example flow can talk to MQTT at `vncp-mosquitto:1883` or PostgreSQL at `vncp-postgresql:5432`.
