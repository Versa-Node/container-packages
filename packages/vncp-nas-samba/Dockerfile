FROM alpine:3.20
RUN apk add --no-cache samba-server samba-common-tools bash shadow   && addgroup -S sambagrp && adduser -S -G sambagrp -H -s /sbin/nologin samba
RUN mkdir -p /shares && chown -R samba:sambagrp /shares
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 445
VOLUME ["/shares"]
HEALTHCHECK --interval=30s --timeout=5s --retries=5 CMD nc -z localhost 445 || exit 1
ENTRYPOINT ["/entrypoint.sh"]
CMD ["smbd","--foreground","--no-process-group","--log-stdout"]
