FROM openhab/openhab:latest

# ---- Metadata ----
LABEL org.opencontainers.image.title="vncp-openhab" \
      org.opencontainers.image.description="openHAB with VNCP dashboard publisher." \
      io.versanode.vncp.config.path="/usr/share/versanode/vncp.config.yaml"

# ---- Defaults visible to UIs and users ----
ENV OPENHAB_HTTP_PORT=8080 \
    OPENHAB_HTTPS_PORT=8443 \
    CRYPTO_POLICY=unlimited \
    EXTRA_JAVA_OPTS="-Duser.timezone=Europe/Berlin" \
    VNCP_PROPS_DIR=/vncp/props \
    VNCP_NAME=vncp-openhab

# Document the VNCP location; users can bind-mount /var/lib/vncp -> /vncp
VOLUME ["/vncp"]

# Document ports (host publishing is done at runtime)
EXPOSE 8080 8443

# Stay root for install/setup; don't switch to 'openhab' here
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
    mkdir -p /vncp/props; \
    chmod -R 0777 /vncp

# ---- VNCP dashboard publisher ----
COPY scripts/vncp-openhab-dashprop /usr/local/bin/vncp-openhab-dashprop
RUN chmod 0755 /usr/local/bin/vncp-openhab-dashprop

# Do NOT 'USER openhab' here; let the base image/entrypoint decide at runtime

# Healthcheck: when openHAB answers locally, publish dashboards JSON into /vncp/props
HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=10 \
  CMD sh -lc 'for url in \
      "https://127.0.0.1:${OPENHAB_HTTPS_PORT:-8443}" \
      "http://127.0.0.1:${OPENHAB_HTTP_PORT:-8080}"; do \
        if curl -skI --connect-timeout 2 --max-time 4 "$url" | grep -qE "HTTP/.* (2..|3..|401|403)"; then \
          /usr/local/bin/vncp-openhab-dashprop || true; exit 0; \
        fi; \
      done; exit 1'
