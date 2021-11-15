FROM alpine:3.14.3@sha256:635f0aa53d99017b38d1a0aa5b2082f7812b03e3cdb299103fe77b5c8a07f1d2

ARG user=squid
ARG group=squid
ARG uid=3128
ARG gid=3128

ENV SQUID_CONFIG_FILE /etc/squid/squid.conf

RUN apk add --no-cache squid

RUN deluser squid 2>/dev/null; delgroup squid 2>/dev/null; \
  addgroup -S ${group} -g ${gid} && \
  adduser -S -u ${uid} -G ${group} -g ${group} -H -D -s /bin/false -h /var/cache/squid ${user} && \
  mkdir -p /var/cache/squid /var/log/squid /var/run/squid && \
  chmod 751 /var/cache/squid /var/log/squid /var/run/squid && \
  chown ${user}:${group} /var/cache/squid /var/log/squid /var/run/squid

VOLUME ["/var/cache/squid"]
EXPOSE 3128/tcp

USER ${user}

CMD ["sh", "-c", "/usr/sbin/squid -f ${SQUID_CONFIG_FILE} --foreground -z && exec /usr/sbin/squid -f ${SQUID_CONFIG_FILE} --foreground -YCd 1"]
