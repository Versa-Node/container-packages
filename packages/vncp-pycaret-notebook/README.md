# vncp-pycaret-notebook

**PyCaret + JupyterLab** in a single container, tuned for VersaNode (arm64) with optional TimescaleDB/PostgreSQL connectivity.

- **Image:** `ghcr.io/versa-node/vncp-pycaret-notebook:latest`
- **Ports:** `8888` (JupyterLab)
- **Volume:** `./work` → `/home/jovyan/work`
- **Network:** `versanode` (so notebooks can reach `vncp-timescaledb`, `vncp-postgresql`, etc.)

## Configure

Edit `vncp.config.yaml` and render a `.env` on the Docker host.

**Keys**
- `JUPYTER_PORT` *(port, default 8888)* — host port for JupyterLab
- `JUPYTER_TOKEN` *(password, secret, default `changeme`)* — auth token required to log in
- `TZ` *(string, default `UTC`)* — container timezone
- `EXTRA_PIP_PACKAGES` *(string, default empty)* — optional space‑separated pip packages to install on container start (e.g., `prophet xgboost`)

**Example `.env`**
```env
JUPYTER_PORT=8888
JUPYTER_TOKEN=supersecret
TZ=Europe/Amsterdam
EXTRA_PIP_PACKAGES=
```

## Connect to TimescaleDB/PostgreSQL

From a notebook:
```python
import pandas as pd
import psycopg2, os

conn = psycopg2.connect(
    host=os.getenv("PGHOST", "vncp-timescaledb"),
    port=int(os.getenv("PGPORT", "5432")),
    user=os.getenv("POSTGRES_USER", "postgres"),
    password=os.getenv("POSTGRES_PASSWORD", "postgres"),
    dbname=os.getenv("POSTGRES_DB", "app"),
)
pd.read_sql("SELECT NOW()", conn)
```

> On the shared `versanode` network, use hostnames like `vncp-timescaledb` or `vncp-postgresql`.

## Run
```bash
bash ../../tools/ensure-network.sh
mkdir -p work
docker compose up -d
```

Then open: `http://<host-ip>:{JUPYTER_PORT}` and use the token from `.env`.
