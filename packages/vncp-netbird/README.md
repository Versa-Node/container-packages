# vncp-netbird

**NetBird** client to join a WireGuard-based mesh network.

- **Image:** `ghcr.io/versa-node/vncp-netbird:latest`
- **Capabilities:** `NET_ADMIN`
- **Devices:** `/dev/net/tun`
- **Network:** `versanode`

## Configure

`vncp.config.yaml` → `.env`

**Keys**
- `NB_SETUP_KEY` *(password, secret, required)* — setup key to enroll this node
- `NB_MANAGEMENT_URL` *(string, default `https://api.netbird.io`)* — management API URL
- `NB_LOG_LEVEL` *(enum, default `info`)* — log level (`trace|debug|info|warn|error`)

**Example `.env`**
```env
NB_SETUP_KEY=nbsk_xxx
NB_MANAGEMENT_URL=https://api.netbird.io
NB_LOG_LEVEL=info
```

## Run
```bash
bash ../../tools/ensure-network.sh
docker compose up -d
```

> This container configures networking inside the host namespace via TUN; some environments (nested virtualization, restricted kernels) may block this.
