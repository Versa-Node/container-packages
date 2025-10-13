# VersaNode n8n (vncp-n8n)

A ready-to-run **n8n automation container** tailored for the **VersaNode** UI.  
This package keeps defaults sensible and makes it simple to launch and access n8n’s web interface without manual Docker commands.

> **Base image:** [`n8nio/n8n`](https://hub.docker.com/r/n8nio/n8n)

💬 **Have questions or ideas?**  
Join the community discussion here → [VersaNode Discussions](https://github.com/orgs/Versa-Node/discussions)

---

## Quick start (VersaNode UI)

1. **Open** the VersaNode containers page and click **Create container**.
2. In the **Image** box, choose or type:
   - `ghcr.io/versa-node/vncp-n8n:latest` (or your tagged build), or
   - `docker.n8n.io/n8nio/n8n:latest` if you don’t need extras.
3. **Name**: Leave the suggested name or set your own.
4. **Command**: Leave blank (uses n8n’s defaults).
5. **Network**: Keep the default VersaNode network, or select host if you prefer.
6. **Ports** (typical):
   - Map **5678 → 5678** for the n8n web UI.
7. **Volumes** (recommended):
   - Map your n8n data folder for persistent workflows and credentials. For example:
     - Host: `/srv/n8n/data` → Container: `/home/node/.n8n`
8. **Environment** (optional, see below).
9. Click **Create and run**. Once the container status shows **Running**, open your browser to:
   - n8n Web UI: `http://<your-host>:5678`

---

## Common options

### Environment variables

| Variable | Default | What it does |
|---|---:|---|---|
| `N8N_PORT` | `5678` | HTTP port inside the container. Usually keep as-is. |
| `GENERIC_TIMEZONE` | `Europe/Berlin` | Timezone used inside n8n. |
| `TZ` | *(unset)* | System timezone (for logs and cron tasks). |
| `DB_TYPE` | `sqlite` | Database type (`sqlite` or `postgresdb`). |
| `DB_POSTGRESDB_HOST` | *(unset)* | PostgreSQL host if using external DB. |
| `DB_POSTGRESDB_DATABASE` | *(unset)* | PostgreSQL database name. |
| `DB_POSTGRESDB_USER` | *(unset)* | PostgreSQL user. |
| `DB_POSTGRESDB_PASSWORD` | *(unset)* | PostgreSQL password. |

> 💡 Tip: To use PostgreSQL, set `DB_TYPE=postgresdb` and configure the connection vars above.  
> You still need to mount `/home/node/.n8n` to persist encryption keys and credentials.

### Volumes (persistence)

To keep your workflows, credentials, and settings between restarts, bind-mount:

- `/home/node/.n8n` – n8n’s working directory

Example mapping (host → container):
- `/srv/n8n/data` → `/home/node/.n8n`

Ensure the host directory is writable by Docker.

---

## Health & readiness

The container includes a lightweight check for the n8n UI.  
Startup may take 30–60 seconds on first run while dependencies initialize.

**Troubleshooting start-up**

- Wait until status shows **Running** (and CPU usage drops).
- Check **Logs** for port or permission issues.
- If you changed ports, verify your mappings match the URL you’re opening.
- Restart the container after updating configuration or environment variables.

---

## Typical setups

**A. Simple local test**
- Ports: `5678:5678`
- Volumes: *(none)*
- Browse: `http://localhost:5678`

**B. Persistent server deployment**
- Ports: `5678:5678`
- Volumes:
  - `/srv/n8n/data:/home/node/.n8n`
- Env: `GENERIC_TIMEZONE=Europe/London`
- Browse: `http://<server>:5678`

**C. PostgreSQL-backed setup**
- Ports: `5678:5678`
- Volumes:
  - `/srv/n8n/data:/home/node/.n8n`
- Env:
  ```bash
  DB_TYPE=postgresdb
  DB_POSTGRESDB_HOST=postgres
  DB_POSTGRESDB_DATABASE=n8n
  DB_POSTGRESDB_USER=n8n
  DB_POSTGRESDB_PASSWORD=secret
  ```

---

## Updating

1. Stop the container.
2. In the create/run dialog, enable **Pull latest image** (or update the tag).
3. Recreate the container with the same **volumes** so your data persists.

> You can safely switch between the official `n8nio/n8n` and `vncp-n8n` image while keeping your `/home/node/.n8n` volume.

---

## Notes for power users

- Use **host networking** only if nothing else occupies port 5678.
- For HTTPS or reverse proxy setups, terminate TLS at your proxy and point to the container’s port 5678.
- The image is compatible with n8n’s official environment variables and database configuration.

---

## Support & references

- n8n docs: https://docs.n8n.io/
- Base image on Docker Hub: https://hub.docker.com/r/n8nio/n8n
- Discuss & get help: [VersaNode Community Discussions](https://github.com/orgs/Versa-Node/discussions)

If you run into setup issues, share the last 50–100 log lines in your support request for faster help.
