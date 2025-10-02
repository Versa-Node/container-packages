# Optional. Delete if using upstream image only.
FROM alpine:3.20
RUN adduser -D -H -u 1000 app &&     mkdir -p /app && chown -R app:app /app
USER app
WORKDIR /app
CMD ["sh", "-c", "echo Template container running; sleep infinity"]
