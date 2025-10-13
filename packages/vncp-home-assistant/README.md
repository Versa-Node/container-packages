# VersaNode Home Assistant (vncp-home-assistant)

A friendly **Home Assistant** container tailored for the **VersaNode** UI.  
This package makes it easy to run and reach Home Assistant without diving into Docker commands — just create, run, and open your smart home dashboard.

> **Base image:** [`homeassistant/home-assistant`](https://hub.docker.com/r/homeassistant/home-assistant/)

💬 **Have questions or ideas?**  
Join the community discussion → [VersaNode Discussions](https://github.com/orgs/Versa-Node/discussions)

---

## 🚀 Quick start (VersaNode UI)

1. **Open** the VersaNode containers page and click **Create container**.  
2. In the **Image** box, choose or type:
   - `ghcr.io/versa-node/vncp-home-assistant:latest` (recommended), or  
   - `homeassistant/home-assistant:stable` if you don’t need VNCP features.
3. **Name**: Leave the suggested name or set your own.  
4. **Command**: Leave blank (uses image defaults).  
5. **Network**: Keep the default VersaNode network, or switch to host mode for discovery features.  
6. **Ports** (typical):
   - Map **8123 → 8123** for the web interface (HTTP).
7. **Volumes** (recommended for persistence):
   - Host: `/srv/homeassistant/config` → Container: `/config`
8. Click **Create and run**.  
   When the container status shows **Running**, open:
   - `http://<your-host>:8123`

---

## ⚙️ Common options

### Environment variables

| Variable | Default | Description |
|-----------|----------|-------------|
| `HASS_HTTP_PORT` | `8123` | Internal web interface port. |
| `TZ` | *(unset)* | Timezone, e.g. `Europe/London` or `America/New_York`. |
| `VNCP_NAME` | `vncp-home-assistant` | Name used in VNCP dashboard metadata. |
| `VNCP_INFO_DIR` | `/vncp` | Where dashboard info JSON is written. |

> 💡 **Tip:** If port 8123 is already in use, map another host port (e.g. `18123:8123`) and open `http://<your-host>:18123`.

---

## 💾 Volumes (persistence)

To keep your Home Assistant configuration and history, bind-mount the `/config` directory:

| Host path | Container path | Description |
|------------|----------------|--------------|
| `/srv/homeassistant/config` | `/config` | Main Home Assistant configuration (automations, settings, history). |

Make sure the host folder exists and is writable by Docker.

---

## 🩺 Health & readiness

The container periodically checks whether Home Assistant is responding on port 8123.  
Once healthy, VersaNode will automatically detect and show a dashboard link.

**Troubleshooting startup:**
- Wait until the container status is **Running** (first boot can take a few minutes).  
- Check **Logs** in VersaNode for errors.  
- Ensure port mappings match your browser URL.  
- Restart after changing volumes or environment variables.

---

## 🧰 Typical setups

**A. Quick local test**
- Ports: `8123:8123`
- Volumes: *(none)*
- Browse: `http://localhost:8123`

**B. Persistent home server**
- Ports: `8123:8123`
- Volumes:
  - `/srv/homeassistant/config:/config`
- Env: `TZ=Europe/London`
- Browse: `http://<server>:8123`

**C. Alternate port**
- Ports: `18123:8123`
- Browse: `http://<server>:18123`

---

## 🔄 Updating

1. Stop the container.  
2. Enable **Pull latest image** or update the tag to `:latest`.  
3. Recreate the container with the same volume mount (`/config`) to retain your data.

---

## 🧠 Notes for power users

- **Network mode “host”** is optional but useful for local discovery (e.g. detecting devices like Philips Hue or Google Cast).  
- The VNCP build writes dashboard info to `/vncp/vncp-info.json` so VersaNode can display a quick link automatically.  
- Fully compatible with upstream Home Assistant updates.  

---

## 🔗 Support & references

- Home Assistant docs: https://www.home-assistant.io/docs/  
- Base image on Docker Hub: https://hub.docker.com/r/homeassistant/home-assistant/  
- Discuss & get help: [VersaNode Community Discussions](https://github.com/orgs/Versa-Node/discussions)

If you’re stuck with port mappings, config folders, or startup issues, copy the last few log lines into your support request.
