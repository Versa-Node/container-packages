# vncp-home-assistant

**Home Assistant** packaged for VersaNode.

- **Image:** `ghcr.io/versa-node/vncp-home-assistant:latest`
- **Network mode:** `host`
- **Volume:** `./config`
- **Network:** still attaches to `versanode` for name resolution (not used with host mode)

## Configure

`vncp.config.yaml` → render `.env` on the host.

**Keys**
- `TZ` *(string, default UTC)* — container timezone
- `CONFIG_PATH` *(path, default `./config`)* — host path for config

Ensure `./config` is on a fast, reliable disk (SSD recommended).

## Run
```bash
bash ../../tools/ensure-network.sh
docker compose up -d
```

> Discovery protocols require host networking (already enabled).
