# syntax=docker/dockerfile:1.6
FROM openhab/openhab:latest-debian

# ---- Metadata ----
LABEL org.opencontainers.image.title="vncp-openhab"
LABEL org.opencontainers.image.description="openHAB with VNCP dashboard publisher."
LABEL io.versanode.vncp.config.path="/usr/share/versanode/vncp.config.yaml"

# ---- Defaults visible to users/UIs ----
ENV OPENHAB_HTTP_PORT=8080 \
    OPENHAB_HTTPS_PORT=8443 \
    CRYPTO_POLICY=unlimited \
    EXTRA_JAVA_OPTS="-Duser.timezone=Europe/Berlin" \
    VNCP_PROPS_DIR=/vncp/props \
    VNCP_NAME=vncp-openhab

# Advertise a logical data location (users may bind-mount /vncp on host)
VOLUME ["/vncp"]

# Expose container ports (hints; host publishes at run-time unless using host network)
EXPOSE 8080 8443

# ---- Tools for healthcheck ----
USER root
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends curl ca-certificates; \
    rm -rf /var/lib/apt/lists/*

# Ensure /vncp/props exists and is writable.
# If the openhab user/group exist, give them ownership; otherwise just make it world-writable.
RUN set -eux; \
    install -d -m 0777 /vncp/props; \
    if getent passwd openhab >/dev/null 2>&1 && getent group openhab >/dev/null 2>&1; then \
      chown -R openhab:openhab /vncp || true; \
      chmod 0775 /vncp /vncp/props || true; \
    fi

# ---- VNCP dashboard publisher ----
COPY scripts/vncp-openhab-dashprop /usr/local/bin/vncp-openhab-dashprop
RUN chmod 0755 /usr/local/bin/vncp-openhab-dashprop

# Back to runtime user if present (the official image defines it)
# If a rare variant lacks the user, the healthcheck & script still work as root.
USER openhab

# ---- Healthcheck writes dashboard prop on success ----
HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=10 \
  CMD sh -lc 'for url in \
      "https://127.0.0.1:${OPENHAB_HTTPS_PORT:-8443}" \
      "http://127.0.0.1:${OPENHAB_HTTP_PORT:-8080}"; do \
        if curl -skI --connect-timeout 2 --max-time 4 "$url" | grep -qE "HTTP/.* (2..|3..|401|403)"; then \
          /usr/local/bin/vncp-openhab-dashprop || true; exit 0; \
        fi; \
      done; exit 1'
