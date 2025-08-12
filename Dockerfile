ARG ALPINE_VERSION=3.22

FROM alpine:${ALPINE_VERSION}

ARG IMAGE_VERSION=1.0.0
ARG BUILD_DATE
ARG ALPINE_VERSION
ARG NOVNC_VERSION

LABEL org.opencontainers.image.title="novnc" \
      org.opencontainers.image.description="Minimal noVNC Docker image for running GUI applications." \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.url="https://github.com/libstash/novnc" \
      org.opencontainers.image.source="https://github.com/libstash/novnc" \
      org.opencontainers.image.documentation="https://github.com/libstash/novnc" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.base.name="alpine" \
      org.opencontainers.image.base.version="${ALPINE_VERSION}" \
      org.opencontainers.image.software.name="novnc" \
      org.opencontainers.image.software.version="${NOVNC_VERSION}"

RUN apk --no-cache add novnc x11vnc xvfb supervisor fluxbox

COPY supervisord.conf /etc/supervisord.conf
COPY docker-entrypoint.sh /

RUN ln -s /usr/share/novnc/vnc.html  /usr/share/novnc/index.html

ENV DISPLAY=:0.0 \
    DISPLAY_WIDTH=1280 \
    DISPLAY_HEIGHT=720

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
  CMD wget --spider -q http://127.0.0.1:8080 || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]