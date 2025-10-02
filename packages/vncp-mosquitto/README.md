# vncp-mosquitto

Eclipse **Mosquitto** MQTT broker packaged for VersaNode.

- **Image:** `ghcr.io/versa-node/vncp-mosquitto:latest`
- **Ports (default):** `1883` (MQTT), `9001` (WebSockets, optional)
- **Volumes:** `./config`, `./data`, `./log`
- **Network:** attaches to external Docker network `versanode`

## Configure

Edit `vncp.config.yaml` (typed parameters) and render a `.env` on the Docker host.

**Keys**
- `MQTT_PORT` *(port, default 1883)* — host port for MQTT
- `WS_ENABLE` *(bool, default true)* — enable MQTT over WebSockets
- `WS_PORT` *(port, default 9001)* — host port for WebSockets
- `ALLOW_ANONYMOUS` *(bool, default false)* — allow unauthenticated clients
- `MQTT_USER` *(string)* — username
- `MQTT_PASSWORD` *(password, secret)* — password

**Example `.env`**
```env
MQTT_PORT=1883
WS_ENABLE=true
WS_PORT=9001
ALLOW_ANONYMOUS=false
MQTT_USER=habibi
MQTT_PASSWORD=supersecret
```

**Password file**
If `ALLOW_ANONYMOUS=false`, create `./config/passwords` using:
```bash
docker run --rm -it -v $(pwd)/config:/work -w /work eclipse-mosquitto:2   mosquitto_passwd -c passwords "$MQTT_USER"
```

> The image ships a `templates/mosquitto.conf.j2`. Your cockpit tool should render
> it to `config/mosquitto.conf` with the `.env` values.

## Run
```bash
bash ../../tools/ensure-network.sh
docker compose up -d
```

Clients on the `versanode` network can connect via `vncp-mosquitto:1883`.
