FROM openhab/openhab:latest

# ---- Metadata ----
LABEL org.opencontainers.image.title="vncp-openhab" \
      org.opencontainers.image.description="openHAB with VNCP dashboard publisher." \
      io.versanode.vncp.network="host" 

# Workflow passes proxies as argument
ARG VNCP_PROXIES=[]
LABEL io.versanode.vncp.proxies="${VNCP_PROXIES}"

# ---- Defaults visible to UIs and users ----
ENV OPENHAB_HTTP_PORT=8080 \
    OPENHAB_HTTPS_PORT=8443 \
    CRYPTO_POLICY=unlimited \
    EXTRA_JAVA_OPTS="-Duser.timezone=Europe/Berlin" \
    VNCP_NAME=vncp-openhab \
    # Optional: override at build time to bake the external URL
    OPENHAB_PUBLIC_BASE_URL="http://localhost/openhab"

EXPOSE 8080 8443

# Stay root for install/setup; don't switch to 'openhab' here
USER 0

# Install curl for healthcheck (covers both Debian and Alpine variants)
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

# Healthcheck: succeed when openHAB answers locally (no side effects)
HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=10 \
  CMD sh -lc 'for url in \
      "https://127.0.0.1:${OPENHAB_HTTPS_PORT:-8443}" \
      "http://127.0.0.1:${OPENHAB_HTTP_PORT:-8080}"; do \
        if curl -skI --connect-timeout 2 --max-time 4 "$url" | grep -qE "HTTP/.* (2..|3..|401|403)"; then \
          exit 0; \
        fi; \
      done; exit 1'
