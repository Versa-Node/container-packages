FROM openhab/openhab:latest

# ---- Metadata ----
LABEL org.opencontainers.image.title="vncp-openhab" \
      org.opencontainers.image.description="openHAB with VNCP dashboard publisher."

# VNCP label as before
ARG VNCP_PROXIES=[]
LABEL io.versanode.vncp.proxies="${VNCP_PROXIES}"

# Defaults
ENV OPENHAB_HTTP_PORT=8080 \
    OPENHAB_HTTPS_PORT=8443 \
    CRYPTO_POLICY=unlimited \
    EXTRA_JAVA_OPTS="-Duser.timezone=Europe/Berlin" \
    VNCP_NAME=vncp-openhab

# (Optional) let you override at build time
ARG PUBLIC_BASE_URL="http://localhost/openhab"
ENV OPENHAB_PUBLIC_BASE_URL="${PUBLIC_BASE_URL}"

# Install curl (unchanged)
USER 0
RUN set -eux; \
    if ! command -v curl >/dev/null 2>&1; then \
      if command -v apt-get >/dev/null 2>&1; then \
        apt-get update; \
        apt-get install -y --no-install-recommends curl ca-certificates; \
        rm -rf /var/lib/apt/lists/*; \
      elif command -v apk >/dev/null 2>&1; then \
        apk add --no-cache curl ca-certificates; \
      fi; \
    fi

# Provide a default network.cfg inside the image.
# NOTE: If you later bind-mount /openhab/conf, your host files will override/hide this.
RUN set -eux; \
    mkdir -p /openhab/conf/services; \
    cat > /openhab/conf/services/network.cfg <<EOF
baseURL = ${OPENHAB_PUBLIC_BASE_URL}
/* Make openHAB trust/consume X-Forwarded-* headers from the proxy */
useHTTPXForwardedHeaders = true
EOF
# Ensure ownership matches the base image user
RUN chown -R openhab:openhab /openhab/conf

# Healthcheck (unchanged)
HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=10 \
  CMD sh -lc 'for url in \
      "https://127.0.0.1:${OPENHAB_HTTPS_PORT:-8443}" \
      "http://127.0.0.1:${OPENHAB_HTTP_PORT:-8080}"; do \
        if curl -skI --connect-timeout 2 --max-time 4 "$url" | grep -qE "HTTP/.* (2..|3..|401|403)"; then \
          exit 0; \
        fi; \
      done; exit 1'
