# syntax=docker/dockerfile:1.6
FROM openhab/openhab:latest-debian

# ---- Metadata ----
LABEL org.opencontainers.image.title="vncp-openhab"
LABEL org.opencontainers.image.description="openHAB home automation platform with VNCP dash publisher."
LABEL io.versanode.vncp.config.path="/usr/share/versanode/vncp.config.yaml"

# ---- Defaults you want visible to UIs and users ----
ENV OPENHAB_HTTP_PORT=8080 \
    OPENHAB_HTTPS_PORT=8443 \
    CRYPTO_POLICY=unlimited \
    EXTRA_JAVA_OPTS="-Duser.timezone=Europe/Berlin" \
    VNCP_PROPS_DIR=/vncp/props \
    VNCP_NAME=vncp-openhab

# Make the VNCP location show up when tools inspect image Config.Volumes
# (Users can still override with a host bind: -v /var/lib/vncp:/vncp)
VOLUME ["/vncp"]

# Expose container ports (documentation/hint; host publishes done at run-time)
EXPOSE 8080 8443

# ---- Tools needed by the healthcheck ----
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Ensure path exists and is writable by openhab
RUN mkdir -p /vncp/props && chown -R openhab:openhab /vncp

# ---- VNCP dashboard publisher ----
COPY scripts/vncp-openhab-dashprop /usr/local/bin/vncp-openhab-dashprop
RUN chmod 0755 /usr/local/bin/vncp-openhab-dashprop

# If you ship a sample compose file too (nice to have)
# COPY compose.example.yml /usr/share/versanode/examples/vncp-openhab.compose.yml

USER openhab

# ---- Healthcheck: updates dashboards prop on success ----
HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=10 \
  CMD sh -lc 'for url in \
      "https://127.0.0.1:${OPENHAB_HTTPS_PORT:-8443}" \
      "http://127.0.0.1:${OPENHAB_HTTP_PORT:-8080}"; do \
        if curl -skI --connect-timeout 2 --max-time 4 "$url" | grep -qE "HTTP/.* (2..|3..|401|403)"; then \
          /usr/local/bin/vncp-openhab-dashprop || true; exit 0; \
        fi; \
      done; exit 1'
