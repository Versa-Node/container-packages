# vncp-postgresql

**PostgreSQL 16** database for VersaNode.

- **Image:** `ghcr.io/versa-node/vncp-postgresql:latest`
- **Port (default):** `5432`
- **Volume:** `./data` → `/var/lib/postgresql/data`
- **Network:** `versanode`

## Configure

`vncp.config.yaml` → `.env`

**Keys**
- `PG_PORT` *(port, default 5432)* — host port
- `POSTGRES_USER` *(string, default `postgres`)* — superuser
- `POSTGRES_PASSWORD` *(password, secret)* — password
- `POSTGRES_DB` *(string, default `app`)* — default DB to create
- `DATA_PATH` *(path, default `./data`)* — host data path

**Example `.env`**
```env
PG_PORT=5432
POSTGRES_USER=postgres
POSTGRES_PASSWORD=strongpass
POSTGRES_DB=app
```

## Run
```bash
bash ../../tools/ensure-network.sh
docker compose up -d
```

**Connect**
```bash
docker exec -it vncp-postgresql psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"
# or from another container on the versanode network: host=vncp-postgresql port=5432
```
