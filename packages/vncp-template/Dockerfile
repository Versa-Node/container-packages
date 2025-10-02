FROM alpine:3.20
RUN adduser -D -H -u 1000 app && mkdir -p /app && chown -R app:app /app
USER app
WORKDIR /app
CMD ["sh", "-c", "echo vncp-template running; sleep infinity"]
LABEL org.opencontainers.image.documentation="https://github.com/Versa-Node/container-packages/tree/main/packages/vncp-template#readme"
