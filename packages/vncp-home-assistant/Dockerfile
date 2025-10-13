FROM homeassistant/home-assistant:latest

# ---- Metadata ----
LABEL org.opencontainers.image.title="vncp-home-assistant" \
      org.opencontainers.image.description="Home Assistant home automation platform."

# ---- Defaults visible to UIs and users ----
# HASS_HTTP_PORT is just a friendly alias for clarity in scripts/healthcheck
ENV HASS_HTTP_PORT=8123 \
    VNCP_INFO_DIR=/vncp \
    VNCP_NAME=vncp-home-assistant

# Document the VNCP location; users can bind-mount /var/lib/vncp -> /vncp
VOLUME ["/vncp"]

# Document ports (host publishing is done at runtime)
EXPOSE 8123

# Stay root for install/setup
USER 0

# Install curl for healthcheck (supports both Debian and Alpine variants)
RUN set -eux; \
    if ! command -v curl >/dev/null 2>&1; then \
      if command -v apt-get >/dev/null 2>&1; then \
        apt-get update; \
        apt-get install -y --no-install-recommends curl ca-certificates; \
        rm -rf /var/lib/apt/lists/*; \
      elif command -v apk >/dev/null 2>&1; then \
        apk add --no-cache curl ca-certificates; \
      else \
        echo "WARN: unknown base, curl not installed"; \
      fi; \
    fi

# Ensure VNCP dir exists and is writable by any runtime UID
RUN set -eux; \
    mkdir -p /vncp; \
    chmod -R 0777 /vncp

# ---- VNCP dashboard publisher ----
# Expect this script to write a JSON like:
# { "name": "...", "dashboards": [{ "name": "Home Assistant", "url": "http://<hostname>:8123" }], ... }
# into $VNCP_INFO_DIR (default /vncp)
COPY scripts/vncp-container-info /usr/local/bin/vncp-container-info
RUN chmod 0755 /usr/local/bin/vncp-container-info

# Do NOT change the user here; let the base image decide at runtime
# USER will be set by the Home Assistant image/entrypoint as appropriate

# Healthcheck: when HA answers locally, publish dashboards JSON into /vncp
HEALTHCHECK --interval=30s --timeout=5s --start-period=120s --retries=10 \
  CMD sh -lc ' \
    url="http://127.0.0.1:${HASS_HTTP_PORT:-8123}"; \
    if curl -sfI --connect-timeout 2 --max-time 4 "$url" | grep -qE "HTTP/.* (2..|3..|401|403)"; then \
      /usr/local/bin/vncp-container-info || true; \
      exit 0; \
    fi; \
    exit 1'
