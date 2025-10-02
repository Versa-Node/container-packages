# vncp-nas-samba

Simple **Samba** NAS share container for VersaNode.

- **Image:** `ghcr.io/versa-node/vncp-nas-samba:latest` (builds locally from Dockerfile)
- **Port:** `445`
- **Volume:** `./data` → `/shares/<ShareName>`
- **Network:** `versanode`

## Configure

`vncp.config.yaml` → `.env`

**Keys**
- `SAMBA_USER` *(string, default `user`)* — username
- `SAMBA_PASS` *(password, secret, default `pass`)* — password
- `SAMBA_SHARE_NAME` *(string, default `share`)* — share name
- `READ_ONLY` *(bool, default `false`)* — make share read-only

**Example `.env`**
```env
SAMBA_USER=habibi
SAMBA_PASS=s3cr3t
SAMBA_SHARE_NAME=data
READ_ONLY=false
```

The container writes a minimal `smb.conf` and creates the share path.

## Run
```bash
bash ../../tools/ensure-network.sh
docker compose up -d
```

Connect from another machine: `\\<host-ip>\data` (Windows) or `smb://<host-ip>/data` (macOS/Linux).
