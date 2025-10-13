# VersaNode OpenHAB (vncp-openhab)

A friendly OpenHAB container tailored for the **VersaNode** UI.  
This package keeps defaults sensible and makes it easy to run and reach OpenHAB (Main UI / HABPanel) without digging into Docker commands.

> **Base image:** [`openhab/openhab`](https://hub.docker.com/r/openhab/openhab/)

💬 **Have questions or ideas?**  
Join the community discussion here → [VersaNode Discussions](https://github.com/orgs/Versa-Node/discussions)

---

## Quick start (VersaNode UI)

1. **Open** the VersaNode containers page and click **Create container**.
2. In the **Image** box, choose or type:
   - `ghcr.io/versa-node/vncp-openhab:latest` (or your tagged build), or
   - `openhab/openhab:latest` if you don’t need extras.
3. **Name**: Leave the suggested name or set your own.
4. **Command**: Leave blank (uses image defaults).
5. **Network**: Keep the default VersaNode network, or switch to host if you prefer.
6. **Ports** (typical):
   - Map **8080 → 8080** for HTTP (Main UI / HABPanel).
   - Optionally map **8443 → 8443** for HTTPS.
7. **Volumes** (recommended):
   - Map your OpenHAB userdata/config (persists settings, add-ons, things, logs). For example:
     - Host: `/srv/openhab/userdata` → Container: `/openhab/userdata`
     - Host: `/srv/openhab/conf` → Container: `/openhab/conf`
8. **Environment** (optional, see below).
9. Click **Create and run**. When the container status is **Running**, open your browser to:
   - Main UI: `http://<your-host>:8080`
   - HABPanel: `http://<your-host>:8080/habpanel`
   - HTTPS: `https://<your-host>:8443`

---

## Common options

### Environment variables
Most users don’t need to change these, but they’re handy for quick tweaks.

| Variable | Default | What it does |
|---|---:|---|---|
| `OPENHAB_HTTP_PORT` | `8080` | HTTP port inside the container. Usually keep as-is and map to a host port. |
| `OPENHAB_HTTPS_PORT` | `8443` | HTTPS port inside the container. |
| `TZ` | *(unset)* | Your timezone, e.g. `Europe/London` or `America/New_York`. |
| `EXTRA_JAVA_OPTS` | `-Duser.timezone=Europe/Berlin` | Extra JVM options for OpenHAB. Change the timezone if needed. |

> 💡 Tip: If host port **8080** is already in use, map another host port (e.g. `18080:8080`) and open `http://<your-host>:18080`.

### Volumes (persistence)
To keep your OpenHAB configuration and state across upgrades/restarts, bind-mount:

- `/openhab/userdata` – runtime data (addons, cache, logs, etc.)
- `/openhab/conf` – your configuration files

Example mappings (host → container):
- `/srv/openhab/userdata` → `/openhab/userdata`
- `/srv/openhab/conf` → `/openhab/conf`

Create the host folders first and ensure they are writable by Docker.

---

## Health & readiness

The container periodically checks whether OpenHAB is reachable on its internal ports. Once reachable, the UI links will work. First start can take a few minutes, especially while add‑ons download.

**Troubleshooting start-up**

- Wait until status shows **Running** (and the CPU/memory usage settles).
- Check **Logs** tab for errors (missing permissions, port conflicts, etc.).
- If you changed ports, confirm your **port mappings** match your browser URL.
- Try restarting the container after changing volumes or environment variables.

---

## Typical setups

**A. Simple local test**
- Ports: `8080:8080`
- Volumes: *(none)*
- Browse: `http://localhost:8080`

**B. Persistent home server**
- Ports: `8080:8080`, `8443:8443`
- Volumes:
  - `/srv/openhab/userdata:/openhab/userdata`
  - `/srv/openhab/conf:/openhab/conf`
- Env: `TZ=Europe/London` (or your timezone)
- Browse: `http://<server>:8080`

**C. Alternate host ports**
- Ports: `18080:8080`
- Browse: `http://<server>:18080`

---

## Updating

1. Stop the container.
2. In the create/run dialog, enable **Pull latest image** (or update the tag).
3. Recreate the container with the same **volumes** so your data persists.

> If you used the plain `openhab/openhab` image before, you can switch images and keep the same volume mounts.

---

## Notes for power users

- You can select **Use host network** if you prefer not to set port mappings. Only do this if the host has no conflicting services on 8080/8443.
- For reverse proxies, leave container ports at defaults (8080/8443) and terminate TLS at your proxy.
- The image retains compatibility with OpenHAB’s standard paths and behavior.

---

## Support & references

- OpenHAB docs: https://www.openhab.org/docs/
- Base image on Docker Hub: https://hub.docker.com/r/openhab/openhab/
- Discuss & get help: [VersaNode Community Discussions](https://github.com/orgs/Versa-Node/discussions)

If you need help choosing ports, volumes, or diagnosing a failed start, open the container’s **Logs** tab and copy the last 50–100 lines into your support request.
