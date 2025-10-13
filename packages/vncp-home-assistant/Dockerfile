FROM homeassistant/home-assistant:latest

# ---- Metadata ----
LABEL org.opencontainers.image.title="vncp-home-assistant" \
      org.opencontainers.image.description="Home Assistant home automation platform." \
      io.versanode.vncp.proxies='[{"slug":"homeassistant","port":8123}]'

# ---- Defaults visible to UIs and users ----
ENV HASS_HTTP_PORT=8123 \
    VNCP_NAME=vncp-home-assistant

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

# Do NOT change user; base image/entrypoint decides at runtime

# Healthcheck: verify Home Assistant responds locally
HEALTHCHECK --interval=30s --timeout=5s --start-period=120s --retries=10 \
  CMD sh -lc 'url="http://127.0.0.1:${HASS_HTTP_PORT:-8123}"; \
    curl -sfI --connect-timeout 2 --max-time 4 "$url" | \
    grep -qE "HTTP/.* (2..|3..|401|403)"'
