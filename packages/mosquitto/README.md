# Mosquitto (MQTT broker)

- Upstream: `eclipse-mosquitto:2`
- Ports: `1883` (MQTT), `9001` (WebSockets)

## Usage

```bash
docker compose -f docker-compose.example.yml up -d
```

Default config enables anonymous *off*; create users with `mosquitto_passwd`.
