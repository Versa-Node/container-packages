# vncp-timescaledb

**TimescaleDB (PostgreSQL 16)** — time-series database built on PostgreSQL.

- **Image:** `ghcr.io/versa-node/vncp-timescaledb:latest` (FROM `timescale/timescaledb:latest-pg16`)
- **Port (default):** `5432`
- **Volume:** `./data` → `/var/lib/postgresql/data`
- **Network:** `versanode`

## Configure

Edit `vncp.config.yaml` and render a `.env` on the Docker host.

**Keys**
- `PG_PORT` *(port, default 5432)* — host port for PostgreSQL
- `POSTGRES_USER` *(string, default `postgres`)* — superuser
- `POSTGRES_PASSWORD` *(password, secret)* — password for superuser
- `POSTGRES_DB` *(string, default `app`)* — default DB to create
- `DATA_PATH` *(path, default `./data`)* — host data path
- `TIMESCALEDB_TELEMETRY` *(enum: `on|off`, default `off`)* — enable/disable telemetry

**Example `.env`**
```env
PG_PORT=5432
POSTGRES_USER=postgres
POSTGRES_PASSWORD=strongpass
POSTGRES_DB=app
TIMESCALEDB_TELEMETRY=off
```

## Enable the extension

After the first start, enable the extension in your database:

```bash
docker exec -it vncp-timescaledb psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS timescaledb;"
```

Create a hypertable (example):

```sql
CREATE TABLE metrics (
  ts TIMESTAMPTZ NOT NULL,
  device TEXT NOT NULL,
  value DOUBLE PRECISION NOT NULL
);

SELECT create_hypertable('metrics', 'ts');
```

## Run
```bash
bash ../../tools/ensure-network.sh
docker compose up -d
```

**Connect**
```bash
docker exec -it vncp-timescaledb psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"
# or from another container on 'versanode': host=vncp-timescaledb port=5432
```
