FROM openhab/openhab:latest-debian
LABEL org.opencontainers.image.description="openHAB home automation platform."
LABEL vncp.config.source=".env"
# Copy dashboard url publisher
COPY scripts/vncp-openhab-dashprop /usr/local/bin/vncp-openhab-dashprop
RUN chmod +x /usr/local/bin/vncp-openhab-dashprop
