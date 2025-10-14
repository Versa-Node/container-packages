################################################################################
# Image:   ghcr.io/versa-node/vncp-openhab
# Purpose: openHAB with VNCP metadata + auto subpath rewriter + dynamic healthcheck
#
# Features:
#  - Detects io.versanode.vncp.proxies (mirrored into $VNCP_PROXIES)
#  - If port=8080, prefixes all /href and /src links with the .path (e.g. /openhab)
#  - Healthcheck dynamically tests http://127.0.0.1/<slug> if port=8080 is present
#  - Idempotent and safe across restarts
################################################################################

FROM openhab/openhab:latest

# ---- Metadata ----
LABEL org.opencontainers.image.title="vncp-openhab" \
      org.opencontainers.image.description="openHAB with VNCP dashboard publisher." \
      io.versanode.vncp.proxies='[{"slug":"openhab","port":8080,"path":"/openhab","set_cookies":["X-OPENHAB-BASEURL=/openhab; Path=/; SameSite=Lax","X-OPENHAB-AUTH-HEADER=1; Path=/; SameSite=Lax"],"headers":{"proxy_set":["Authorization:"]}}]'

# ---- Defaults visible to UIs and users ----
ENV OPENHAB_HTTP_PORT=8080 \
    OPENHAB_HTTPS_PORT=8443 \
    CRYPTO_POLICY=unlimited \
    EXTRA_JAVA_OPTS="-Duser.timezone=Europe/Berlin" \
    VNCP_NAME=vncp-openhab \
    VNCP_PROXIES='[{"slug":"openhab","port":8080,"path":"/openhab","set_cookies":["X-OPENHAB-BASEURL=/openhab; Path=/; SameSite=Lax","X-OPENHAB-AUTH-HEADER=1; Path=/; SameSite=Lax"],"headers":{"proxy_set":["Authorization:"]}}]'

EXPOSE 8080 8443

USER 0

# --- Install dependencies ---
RUN set -eux; \
    if command -v apt-get >/dev/null 2>&1; then \
      apt-get update && apt-get install -y --no-install-recommends curl jq ca-certificates && rm -rf /var/lib/apt/lists/*; \
    elif command -v apk >/dev/null 2>&1; then \
      apk add --no-cache curl jq ca-certificates; \
    else \
      echo "WARN: unknown base, could not install jq/curl"; \
    fi

# --- Copy helper scripts ---
COPY scripts/vncp-prefix-rewrite /usr/local/bin/vncp-prefix-rewrite
COPY scripts/vncp-start /usr/local/bin/vncp-start
COPY scripts/vncp-healthcheck /usr/local/bin/vncp-healthcheck
RUN chmod 0755 /usr/local/bin/vncp-prefix-rewrite /usr/local/bin/vncp-start /usr/local/bin/vncp-healthcheck

ENTRYPOINT ["/usr/local/bin/vncp-start"]
CMD ["tini","-s","./start.sh"]

# --- Dynamic Healthcheck ---
# Checks /<slug> if port=8080 exists, else default / on localhost
HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=10 \
  CMD /usr/local/bin/vncp-healthcheck
