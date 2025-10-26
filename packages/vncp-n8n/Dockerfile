# Dockerfile
FROM n8nio/n8n:latest

# ---- Metadata ----
LABEL org.opencontainers.image.title="vncp-n8n" \
      org.opencontainers.image.description="n8n workflow automation platform" \
      io.versanode.vncp.network="host"

# Workflow passes proxies as argument
ARG VNCP_PROXIES=[]
LABEL io.versanode.vncp.proxies="${VNCP_PROXIES}"

# ---- Defaults visible to UIs and users ----
# n8n listens on 5678 by default
ENV N8N_PORT=5678 \
    GENERIC_TIMEZONE="UTC" \
    TZ="UTC" \
    DB_TYPE=sqlite \
    VNCP_NAME=vncp-n8n \
    \
    # ---- Path-based reverse proxy config ----
    # IMPORTANT: trailing slash is required
    N8N_PATH="/n8n/" \
    N8N_PROTOCOL="https" \
    N8N_HOST="versanode" \
    \
    # Editor + webhook base URLs arrive through the proxy at /n8n/
    N8N_EDITOR_BASE_URL="https://versanode/n8n/" \
    WEBHOOK_URL="https://versanode/n8n/" \
    WEBHOOK_TUNNEL_URL="https://versanode/n8n/" \
    \
    # Endpoints are relative to N8N_PATH – do NOT prefix with /n8n
    N8N_ENDPOINT_REST="/rest" \
    N8N_ENDPOINT_WEBHOOK="/webhook" \
    N8N_ENDPOINT_WEBHOOK_TEST="/webhook-test"

# Persist n8n user data (credentials, encryption key, sqlite DB)
VOLUME ["/home/node/.n8n"]

# Expose n8n HTTP port (host publishing done at runtime)
EXPOSE 5678

# Stay root for install/setup; the entrypoint will drop privileges as needed
USER 0

# Install curl for healthcheck (Debian/Alpine compatible)
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

# Healthcheck: succeed when n8n answers locally (no side effects)
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=10 \
  CMD sh -lc 'url="http://127.0.0.1:${N8N_PORT:-5678}"; \
    curl -sfI --connect-timeout 2 --max-time 4 "$url" | grep -qE "HTTP/.* (2..|3..|401|403)"'
