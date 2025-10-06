# vncp-n8n

Upstream (ARM64-only): `docker.io/n8nio/n8n:1.115.0-arm64`

- **Image:** `ghcr.io/versa-node/vncp-n8n:latest`
- **Arch:** ARM64 (Raspberry Pi, ARM64 servers)
- **Network:** `versanode`
- **Compose:** uses `env_file: .env`
- **Data:** `./data -> /home/node/.n8n`

### Run
```bash
bash ../../tools/ensure-network.sh
docker compose up -d
