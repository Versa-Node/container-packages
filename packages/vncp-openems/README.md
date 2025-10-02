# vncp-openems (Edge)

**OpenEMS Edge** packaged for VersaNode.

- **Image:** `ghcr.io/versa-node/vncp-openems:latest`
- **Ports (default):** `8080` HTTP UI/API, `8075` WebSocket API
- **Volume:** `./data` → `/var/openems`
- **Network:** `versanode`

## Configure

`vncp.config.yaml` → `.env` on host.

**Keys**
- `HTTP_PORT` *(port, default 8080)* — host port for HTTP UI/API
- `WS_PORT` *(port, default 8075)* — host port for WebSocket API
- `LOG_LEVEL` *(enum: TRACE|DEBUG|INFO|WARN|ERROR, default INFO)* — log verbosity

**WebSocket**
Enable `Controller.Api.Websocket` in your Edge configuration to use WS at `8075`.

## Run
```bash
bash ../../tools/ensure-network.sh
docker compose up -d
```

Access: `http://localhost:${HTTP_PORT:-8080}`
