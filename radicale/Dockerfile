FROM tomsquest/docker-radicale:3.1.8.0

COPY ./config /config/config

HEALTHCHECK  --interval=60s --timeout=10s --retries=3 \
  CMD curl --fail http://localhost:9800 || exit 1

# web ui
EXPOSE 9800

CMD ["radicale", "--config", "/config/config"]