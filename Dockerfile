FROM alpine:3.15.0@sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300

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
