FROM docker.io/timescale/timescaledb:latest-pg16
# Copy the config and README into the image
COPY vncp.config.yaml ${VNCP_DIR}/vncp.config.yaml
COPY README.md        ${VNCP_DIR}/README.md

# (optional) make them readable
RUN chmod 0644 ${VNCP_DIR}/vncp.config.yaml ${VNCP_DIR}/README.md

# Labels: point to where they live, plus a human-readable description
LABEL io.versanode.vncp.config.path="${VNCP_DIR}/vncp.config.yaml" \
      io.versanode.vncp.readme.path="${VNCP_DIR}/README.md" \
      org.opencontainers.image.description="TimescaleDB (PostgreSQL extension) for time-series."
LABEL org.opencontainers.image.licenses="Apache-2.0"
