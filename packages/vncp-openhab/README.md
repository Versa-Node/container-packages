# vncp-openhab — dashboard property publisher

This package publishes a *property* (JSON file) that lists one or more dashboards
exposed by the container, so the host can easily discover and link to them.

## What gets written
A file named `/var/lib/vncp/props/<container>.dashboards.json` on the host, e.g.:

```json
{
  "name": "vncp-openhab",
  "dashboards": [
    { "name": "HABPanel", "url": "http://localhost:8080" }
  ],
  "meta": {
    "image": "openhab/openhab:latest-debian",
    "timestamp": "2025-01-01T00:00:00Z"
  }
}
```

The `HABPanel` URL is computed from `OPENHAB_HTTP_PORT` (default 8080).
Each package can script its own discovery logic in `scripts/vncp-openhab-dashprop`.

## How it works
- A small script (`/usr/local/bin/vncp-openhab-dashprop`) writes the JSON on startup (via healthcheck start period) and every 30s.
- The script writes to `/vncp/props` inside the container, which is a bind-mount to `/var/lib/vncp/props` on the host.

## Usage
```bash
bash ../../tools/ensure-network.sh
cp .env.example .env  # adjust ports if needed
docker compose up -d
```

## Customize
- Change the published dashboard list by editing `scripts/vncp-openhab-dashprop`.
- Override container name in JSON via `VNCP_NAME` in `.env`.
- Change host registry path by altering the compose volume mapping.

## Notes
- Using `localhost` assumes the host/browser can reach the port mapping directly. Adjust to your hostname or proxy URL if needed.
