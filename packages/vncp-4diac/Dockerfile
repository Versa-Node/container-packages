# ------------------------------------------------------------------------------
# Build stage: build 4diac FORTE with SysFs, ETH, HTTP, etc.
# ------------------------------------------------------------------------------

FROM debian:trixie-slim AS forte-builder

ENV DEBIAN_FRONTEND=noninteractive

# Basic build deps for 4diac FORTE (POSIX build)
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    build-essential \
    cmake; \
  rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/4diac-forte

# You can pin to a specific tag/branch if you prefer, e.g. v2.2.0
ARG FORTE_BRANCH=release
RUN git clone --depth 1 --branch "${FORTE_BRANCH}" \
      https://github.com/eclipse-4diac/4diac-forte.git ./

# Configure & build FORTE for POSIX with SysFs and modules similar to buildForte.sh
RUN set -eux; \
  mkdir -p build && cd build; \
  cmake -G "Unix Makefiles" \
    -DCMAKE_BUILD_TYPE=Release \
    -DFORTE_BUILD_EXECUTABLE=ON \
    -DFORTE_LOGLEVEL=Debug \
    -DFORTE_ARCHITECTURE=Posix \
    -DFORTE_MODULE_SysFs=ON \
    -DFORTE_COM_ETH=ON \
    -DFORTE_COM_LOCAL=ON \
    -DFORTE_MODULE_UTILS=ON \
    -DFORTE_MODULE_CONVERT=ON \
    -DFORTE_MODULE_IEC61131=ON \
    -DFORTE_MODULE_Arrowhead=ON \
    -DFORTE_COM_HTTP=ON \
    -DFORTE_COM_HTTP_LISTENING_PORT=8080 \
    ..; \
  make -j"$(nproc)"; \
  make install DESTDIR=/usr/forte_root

# ------------------------------------------------------------------------------
# Runtime stage: vncp-4diac
# ------------------------------------------------------------------------------

FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

# ---- Metadata ----
LABEL org.opencontainers.image.title="vncp-4diac" \
      org.opencontainers.image.description="Eclipse 4diac FORTE runtime (IEC 61499) with SysFs and HTTP/ETH communication" \
      io.versanode.vncp.network="versanode"

# ---- Defaults visible to UIs and users ----
ENV GENERIC_TIMEZONE="UTC" \
    TZ="UTC" \
    VNCP_NAME="vncp-4diac" \
    FORTE_PORT=61499 \
    FORTE_BOOT_FILE=/usr/forte_boot/forte.fboot

# Install runtime deps + tools used in healthcheck
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    ca-certificates \
    netcat-openbsd \
    curl; \
  rm -rf /var/lib/apt/lists/*

# Copy built FORTE from builder stage
COPY --from=forte-builder /usr/forte_root/ /

# Directory for boot files / config (mounted as volume)
RUN set -eux; \
  mkdir -p /usr/forte_boot

VOLUME ["/usr/forte_boot"]

# 4diac FORTE management + some extra ports
#  - 61499: management / deployment (main one you care about)
#  - 61500: free extra (matching their example)
#  - 8080: HTTP com layer (FORTE_COM_HTTP_LISTENING_PORT)
EXPOSE 61499 61500 8080

# Stay root; orchestrator / entrypoint can drop privileges if needed
USER 0

# Healthcheck: verify that FORTE is listening on the configured TCP port
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=10 \
  CMD sh -lc 'nc -z 127.0.0.1 "${FORTE_PORT:-61499}"'

# Default command:
#  -f  : boot file with initial application (if present)
#  -c  : address:port FORTE listens on (0.0.0.0 so it’s reachable from outside)
CMD ["sh", "-lc", "exec forte -f \"${FORTE_BOOT_FILE}\" -c 0.0.0.0:\"${FORTE_PORT:-61499}\""]
