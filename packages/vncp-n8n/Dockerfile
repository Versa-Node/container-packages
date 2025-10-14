FROM n8nio/n8n:latest

# ---- Metadata ----
LABEL org.opencontainers.image.title="vncp-n8n" \
      org.opencontainers.image.description="n8n workflow automation platform" \
      io.versanode.vncp.proxies='[{"slug": "openhab","port": 8080,"nginx_block": "location = ${PATH} { return 308 ${PATH}/; }\nlocation ^~ ${PATH}/ {\n    rewrite ^${PATH}/(.*)$ /$1 break;\n    proxy_http_version 1.1;\n    proxy_set_header Upgrade $http_upgrade;\n    proxy_set_header Connection $connection_upgrade;\n    proxy_set_header Host $host;\n    proxy_set_header X-Real-IP $remote_addr;\n    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n    proxy_set_header X-Forwarded-Proto $scheme;\n    sub_filter_once off;\n    sub_filter_types text/html text/css application/javascript application/json text/plain;\n    sub_filter '\''href=\"/'\'' '\''href=\"${PATH}/'\'';\n    sub_filter '\''src=\"/'\'' '\''src=\"${PATH}/'\'';\n    sub_filter '\''action=\"/'\'' '\''action=\"${PATH}/'\'';\n    sub_filter '\''url(/'\'' '\''url(${PATH}/'\'';\n    proxy_pass ${UPSTREAM};\n}"}]'

# ---- Defaults visible to UIs and users ----
# n8n listens on 5678 by default
ENV N8N_PORT=5678 \
    GENERIC_TIMEZONE="UTC" \
    TZ="UTC" \
    DB_TYPE=sqlite \
    VNCP_NAME=vncp-n8n

# Persist n8n user data (credentials, encryption key, sqlite DB)
# Base image uses /home/node/.n8n — declare for clarity
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
