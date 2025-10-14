FROM openhab/openhab:latest

# ---- Metadata ----
LABEL org.opencontainers.image.title="vncp-openhab" \
      org.opencontainers.image.description="openHAB with VNCP dashboard publisher." \
      io.versanode.vncp.proxies='[{"slug":"openhab","port":8080,"nginx_block":"location = ${PATH} { return 308 ${PATH}/; }\nlocation ^~ ${PATH}/ {\n    rewrite ^${PATH}/(.*)$ /$1 break;\n    proxy_http_version 1.1;\n    proxy_set_header Upgrade $http_upgrade;\n    proxy_set_header Connection $connection_upgrade;\n    proxy_set_header Host $host;\n    proxy_set_header X-Real-IP $remote_addr;\n    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n    proxy_set_header X-Forwarded-Proto $scheme;\n    sub_filter_once off;\n    sub_filter_types text/html text/css application/javascript application/json text/plain;\n    sub_filter \'href=\"/\' \'href=\"${PATH}/\';\n    sub_filter \'src=\"/\'  \'src=\"${PATH}/\';\n    sub_filter \'action=\"/\' \'action=\"${PATH}/\';\n    sub_filter \'url(/\' \'url(${PATH}/\';\n    proxy_pass ${UPSTREAM};\n}"}]'


# ---- Defaults visible to UIs and users ----
ENV OPENHAB_HTTP_PORT=8080 \
    OPENHAB_HTTPS_PORT=8443 \
    CRYPTO_POLICY=unlimited \
    EXTRA_JAVA_OPTS="-Duser.timezone=Europe/Berlin" \
    VNCP_NAME=vncp-openhab

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

# Healthcheck: succeed when openHAB answers locally (no side effects)
HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=10 \
  CMD sh -lc 'for url in \
      "https://127.0.0.1:${OPENHAB_HTTPS_PORT:-8443}" \
      "http://127.0.0.1:${OPENHAB_HTTP_PORT:-8080}"; do \
        if curl -skI --connect-timeout 2 --max-time 4 "$url" | grep -qE "HTTP/.* (2..|3..|401|403)"; then \
          exit 0; \
        fi; \
      done; exit 1'
