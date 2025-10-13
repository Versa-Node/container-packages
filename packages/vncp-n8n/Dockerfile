FROM n8nio/n8n:latest

# ---- Metadata ----
LABEL org.opencontainers.image.title="vncp-n8n" \
      org.opencontainers.image.description="n8n workflow automation platform"

# ---- Defaults visible to UIs and users ----
# N8N listens on 5678 by default
ENV N8N_PORT=5678 \
    GENERIC_TIMEZONE="UTC" \
    TZ="UTC" \
    \
    # VNCP defaults
    VNCP_INFO_DIR=/vncp \
    VNCP_NAME=vncp-n8n \
    # Optional: public base (e.g. http://<hostname>)
    # VNCP_PUBLIC_BASE= \
    \
    # Optional DB settings (n8n will default to SQLite when unset)
    DB_TYPE=sqlite

# Document the VNCP location; users can bind-mount /var/lib/vncp -> /vncp
VOLUME ["/vncp"]

# n8n user data (credentials, encryption key, sqlite DB)
# NOTE: base image already uses /home/node/.n8n — persist it in compose/run
# (We declare it explicitly for clarity; Docker will treat it as an anonymous volume if not mapped)
VOLUME ["/home/node/.n8n"]

# Expose n8n HTTP port (host publishing is done at runtime)
EXPOSE 5678

# Stay root for install/setup; let entrypoint drop privileges as needed
USER 0

# Install curl for healthcheck (works on Debian/Alpine variants used by n8n)
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
    mkdir -p /vncp; \
    chmod -R 0777 /vncp

# ---- VNCP dashboard publisher ----
# Reuse the same publisher you use in vncp-openhab
# (expects VNCP_* env; writes /vncp/vncp-info.json with dashboards[])
COPY scripts/vncp-container-info /usr/local/bin/vncp-container-info
RUN chmod 0755 /usr/local/bin/vncp-container-info

# Healthcheck: when n8n answers locally, publish dashboards JSON into /vncp
# - Accept 2xx/3xx/401/403 as "responding"
# - After a good response, invoke the VNCP publisher (ignore publisher errors)
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=10 \
  CMD sh -lc ' \
    url="http://127.0.0.1:${N8N_PORT:-5678}"; \
    if curl -skI --connect-timeout 2 --max-time 4 "$url" | grep -qE "HTTP/.* (2..|3..|401|403)"; then \
      /usr/local/bin/vncp-container-info || true; \
      exit 0; \
    fi; \
    exit 1'

# NOTE:
# - Map /home/node/.n8n on the host for persistence:
#     -v n8n_data:/home/node/.n8n
# - Map /var/lib/vncp on the host to /vncp so VersaNode can read the published JSON:
#     -v /var/lib/vncp:/vncp
# - Publish 5678 to your preferred host port:
#     -p 5678:5678
#
# Example run:
#   docker volume create n8n_data
#   docker run -d \
#     --name vncp-n8n \
#     -p 5678:5678 \
#     -e GENERIC_TIMEZONE="Europe/Berlin" -e TZ="Europe/Berlin" \
#     -v n8n_data:/home/node/.n8n \
#     -v /var/lib/vncp:/vncp \
#     ghcr.io/versa-node/vncp-n8n:latest
