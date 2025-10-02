# Samba NAS

Simple Samba-based NAS for a single share. For multi-user production setups, consider a hardened NAS solution.

## Usage

```bash
export SAMBA_USER=user
export SAMBA_PASS=pass
export SAMBA_SHARE_NAME=share
docker compose -f docker-compose.example.yml up -d
```
