################################################################################
# Image:   ghcr.io/versa-node/vncp-openhab
# Purpose: openHAB with VNCP metadata AND an optional subpath prefix rewriter
#
# What this does
#  - Exposes openHAB as usual (8080/8443)
#  - Adds label io.versanode.vncp.proxies with slug/port/path/etc.
#  - Duplicates that label JSON into ENV VNCP_PROXIES so the runtime can read it
#  - On container start, only if VNCP_PROXIES contains an entry with port==8080,
#    it parses that entry’s "path" (or falls back to "/<slug>") and runs a tiny
#    asset-prefix rewriter that changes absolute refs like href="/..." or
#    src="/..." to href="/<path>/..." / src="/<path>/...".
#  - The rewriter is idempotent (won’t double-prefix) and runs once per boot.
#
# Prefer the official way for openHAB subpath:
#    -e OPENHAB_HTTP_CONTEXT_PATH=/openhab
# If you can set that, the rewriter will still be safe but unnecessary.
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
    VNCP_NAME=vncp-openhab

# Duplicate the label JSON into an env var the runtime can read
# (containers can’t easily read their own labels, so we mirror it here)
ENV VNCP_PROXIES='[{"slug":"openhab","port":8080,"path":"/openhab","set_cookies":["X-OPENHAB-BASEURL=/openhab; Path=/; SameSite=Lax","X-OPENHAB-AUTH-HEADER=1; Path=/; SameSite=Lax"],"headers":{"proxy_set":["Authorization:"]}}]'

# Document ports (host publishing is done at runtime)
EXPOSE 8080 8443

# Stay root for install/setup; don't switch to 'openhab' here
USER 0

# Install curl + jq for healthcheck and JSON parsing (Debian/Alpine safe)
RUN set -eux; \
    if ! command -v curl >/dev/null 2>&1; then \
      if command -v apt-get >/dev/null 2>&1; then \
        apt-get update; \
        apt-get install -y --no-install-recommends curl ca-certificates jq; \
        rm -rf /var/lib/apt/lists/*; \
      elif command -v apk >/dev/null 2>&1; then \
        apk add --no-cache curl ca-certificates jq; \
      else \
        echo "WARN: unknown base, curl not installed"; \
      fi; \
    else \
      if command -v apt-get >/dev/null 2>&1; then \
        apt-get update; \
        apt-get install -y --no-install-recommends jq; \
        rm -rf /var/lib/apt/lists/*; \
      elif command -v apk >/dev/null 2>&1; then \
        apk add --no-cache jq; \
      fi; \
    fi

# --- Prefix rewriter + start shim ---
# VNCP_PREFIX-REWRITE: only runs at start IF VNCP_PROXIES has an entry with port==8080
# It uses the entry's "path" when present, else "/<slug>"
COPY scripts/vncp-prefix-rewrite /usr/local/bin/vncp-prefix-rewrite
COPY scripts/vncp-start           /usr/local/bin/vncp-start
RUN chmod 0755 /usr/local/bin/vncp-prefix-rewrite /usr/local/bin/vncp-start

# Use our start shim as entrypoint; it will exec the base entrypoint afterward
ENTRYPOINT ["/usr/local/bin/vncp-start"]

# Healthcheck: succeed when openHAB answers locally (no side effects)
HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=10 \
  CMD sh -lc 'for url in \
      "https://127.0.0.1:${OPENHAB_HTTPS_PORT:-8443}" \
      "http://127.0.0.1:${OPENHAB_HTTP_PORT:-8080}"; do \
        if curl -skI --connect-timeout 2 --max-time 4 "$url" | grep -qE "HTTP/.* (2..|3..|401|403)"; then \
          exit 0; \
        fi; \
      done; exit 1'
