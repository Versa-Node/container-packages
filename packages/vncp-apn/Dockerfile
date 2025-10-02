FROM debian:stable-slim
RUN apt-get update && apt-get install -y --no-install-recommends ppp iproute2 iputils-ping ca-certificates && rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
LABEL org.opencontainers.image.documentation="https://github.com/Versa-Node/container-packages/tree/main/packages/vncp-apn#readme"
