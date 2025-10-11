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

USER 0

# Install curl (Debian or Alpine) for healthcheck; no-op if already present
RUN set -eux; \
    if ! command -v curl >/dev/null 2>&1; then \
      if command -v apt-get >/dev/null 2>&1; then \
        apt-get update && \
        apt-get install -y --no-install-recommends curl ca-certificates && \
        rm -rf /var/lib/apt/lists/*; \
      elif command -v apk >/dev/null 2>&1; then \
        apk add --no-cache curl ca-certificates; \
      else \
        echo "WARN: unknown base, curl not installed"; \
      fi; \
    fi

# Ensure VNCP dir exists and is writable.
# If 'openhab' user exists, own it; otherwise, make it world-writable as a safe fallback.
RUN set -eux; \
    mkdir -p /vncp/props; \
    if id -u openhab >/dev/null 2>&1; then \
      chown -R openhab:openhab /vncp; \
      chmod -R 0775 /vncp; \
    else \
      chmod -R 0777 /vncp; \
    fi

# ---- VNCP dashboard publisher ----
COPY scripts/vncp-openhab-dashprop /usr/local/bin/vncp-openhab-dashprop
RUN chmod 0755 /usr/local/bin/vncp-openhab-dashprop

# Switch back to openhab if present (typical for official images); otherwise stay root.
# (This will succeed on official openHAB images. If you ever swap to a base without that user,
#  build with --build-arg BASE_TAG=<an openHAB tag> or remove this USER line.)
USER openhab

# Healthcheck: when OH answers locally, publish dashboards JSON into /vncp/props
HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=10 \
  CMD sh -lc 'for url in \
      "https://127.0.0.1:${OPENHAB_HTTPS_PORT:-8443}" \
      "http://127.0.0.1:${OPENHAB_HTTP_PORT:-8080}"; do \
        if curl -skI --connect-timeout 2 --max-time 4 "$url" | grep -qE "HTTP/.* (2..|3..|401|403)"; then \
          /usr/local/bin/vncp-openhab-dashprop || true; exit 0; \
        fi; \
      done; exit 1'
