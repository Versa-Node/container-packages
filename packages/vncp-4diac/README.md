# VersaNode 4diac FORTE (vncp-4diac)

A ready-to-run **Eclipse 4diac FORTE** runtime container tailored for the **VersaNode**.  
This package keeps defaults sensible and makes it simple to launch and connect your IEC 61499 applications without manual Docker commands.

<img src="https://eclipse.dev/4diac/img/downloads/powerdby4diac_large_dark.png" width="50%">


> **Base image:** [`ghcr.io/versa-node/vncp-4diac`](https://github.com/Versa-Node)  
> Built from Debian Trixie (headless) with Eclipse 4diac FORTE (Posix) and SysFs support for Raspberry Pi GPIO.

💬 **Have questions or ideas?**  
Join the community discussion here → [VersaNode Discussions](https://github.com/orgs/Versa-Node/discussions)

---

## Quick start (VersaNode UI)

1. **Open** the VersaNode containers page and click **Create container**.
2. In the **Image** box, choose or type (for example):
   - `ghcr.io/versa-node/vncp-4diac:latest` (recommended), or
   - your own tagged fork if you maintain a custom build.
3. **Name**: Leave the suggested name or set your own (e.g. `4diac`, `plc-runtime`).
4. **Command**: Leave blank to use the default FORTE command.
5. **Network**: Keep the default VersaNode network, or select host if you need direct access to field devices.
6. **Ports** (typical):
   - Map **61499 → 61499** for the FORTE management/deployment interface (used by 4diac IDE).
7. **Volumes** (recommended):
   - Map a folder for your **boot/application files** so they persist and are easy to edit:
     - Host: `/srv/4diac/boot` → Container: `/usr/forte_boot`
8. **Environment** (optional but useful, see below).
9. Click **Create and run**. Once the container status shows **Running**, point your 4diac IDE to:
   - `tcp://<your-host>:61499`

---

## Common options

### Environment variables

| Variable | Default | What it does |
|---|---:|---|---|
| `GENERIC_TIMEZONE` | `UTC` | Generic timezone hint used by VersaNode and the container. |
| `TZ` | `UTC` | System timezone (affects logs and time-based function blocks). |
| `VNCP_NAME` | `vncp-4diac` | Human-friendly name shown in VersaNode. |
| `FORTE_PORT` | `61499` | TCP port FORTE listens on for management/deployment. |
| `FORTE_BOOT_FILE` | `/usr/forte_boot/forte.fboot` | Path to the boot file that FORTE loads on startup (if present). |

> 💡 **Boot files**: Use 4diac IDE to export a boot file (`*.fboot`) and place it in your mounted boot directory.  
> Then either use the default path (`/usr/forte_boot/forte.fboot`) or override `FORTE_BOOT_FILE` to point to a different file.

### Volumes (persistence & configuration)

Typical bind mounts:

- `/usr/forte_boot` – directory where you keep boot files, configs, and application snapshots.

Example mapping (host → container):

- `/srv/4diac/boot` → `/usr/forte_boot`

Ensure the host directory is writable by Docker and that the user running the container can read the boot file.

### GPIO / Raspberry Pi usage (optional)

If you use SysFs-based GPIO (as described in the 4diac Raspberry Pi documentation), you’ll typically need to:

- Run on a Raspberry Pi host (or compatible), and
- Pass through the required devices / file systems, for example:

```text
/sys:/sys:ro
```

…and any other device mappings your setup requires.  
Consult your platform documentation and the [4diac Raspberry Pi installation guide](https://eclipse.dev/4diac/doc/installation/raspi.html) for details.

---

## Health & readiness

The container includes a lightweight health check that verifies FORTE is listening on `FORTE_PORT` (default `61499`).  
Startup is usually fast, but if you load a complex boot file it may take a bit longer.

**Troubleshooting start-up**

- Wait until the status shows **Running**.
- Check **Logs** in VersaNode for:
  - Boot file not found or syntax errors.
  - Port already in use.
  - Missing permissions for GPIO or other hardware.
- If you changed `FORTE_PORT`, make sure your port mapping and 4diac IDE target match the new value.
- Restart the container after updating volumes, boot files, or environment variables.

---

## Typical setups

### A. Simple local test (no boot file)

- Ports: `61499:61499`
- Volumes: *(none)*
- Start FORTE: container uses the default command with no boot file.
- In 4diac IDE, add a new device and set the IP/host to your VersaNode host and port `61499`.

### B. Boot-file based application

- Ports: `61499:61499`
- Volumes:
  - `/srv/4diac/boot:/usr/forte_boot`
- Env (optional):
  - `FORTE_BOOT_FILE=/usr/forte_boot/myapp.fboot`
- Export a boot file from your 4diac IDE project to `/srv/4diac/boot/myapp.fboot`.
- Restart the container after updating the boot file.

### C. Raspberry Pi GPIO setup

- Host: a Raspberry Pi or compatible board.
- Ports: `61499:61499`
- Volumes / devices:
  - `/srv/4diac/boot:/usr/forte_boot`
  - `/sys:/sys:ro` (and other device mounts as needed)
- Env:
  - `TZ=Europe/Berlin` (or your local timezone)
- Configure your IEC 61499 application to use the SysFs I/O function blocks as described in the 4diac docs.

---

## Updating

1. Stop the container.
2. In the create/run dialog, enable **Pull latest image** (or update the tag to a specific version).
3. Recreate the container with the same **volumes** so your boot files and configuration persist.

> You can safely switch between different `vncp-4diac` tags as long as your `/usr/forte_boot` volume is preserved.

---

## Notes for power users

- Use **host networking** only if you know there are no conflicts on port `61499`.
- You can expose additional ports if your function blocks or communication setup require them.
- Combine this runtime with other VersaNode containers (databases, APIs, dashboards) on the same network for more complex systems.
- The image is designed to be minimal and headless, suitable for edge/industrial deployments.

---

## Support & references

- Eclipse 4diac project: https://eclipse.dev/4diac/
- 4diac Raspberry Pi installation guide: https://eclipse.dev/4diac/doc/installation/raspi.html
- Discuss & get help: [VersaNode Community Discussions](https://github.com/orgs/Versa-Node/discussions)

If you run into setup issues, share the last 50–100 log lines and your container configuration (ports, volumes, env vars) in your support request for faster help.
