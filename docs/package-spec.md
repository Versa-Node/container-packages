# Package spec

Each package should include `package.yaml`:

```yaml
name: <string>
description: <short>
arch: [linux/arm64, linux/amd64]
maintainers:
  - name: Your Name
    github: yourhandle
upstream:
  image: ghcr.io/...   # or null if custom Dockerfile
ports:
  - "1883:1883"        # if applicable
volumes:
  - "./data:/data"
env:
  - MQTT_USER=...
  - MQTT_PASSWORD=...
healthcheck:
  test: ["CMD", "your", "check"]
  interval: 30s
  timeout: 5s
  retries: 3
```

Compose example should be minimal and secure-by-default.
