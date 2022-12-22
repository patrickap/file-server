# stage 0
FROM alpine:latest

ARG HOST_IP
ARG HOST_NAME

COPY ./db.zone.template /config/db.zone.template

# create dns zone from template
RUN apk add gettext && envsubst '${HOST_IP} ${HOST_NAME}' < /config/db.zone.template > /config/db.${HOST_NAME}

# stage 1
FROM coredns/coredns:1.9.4

ARG HOST_IP
ENV HOST_IP=$HOST_IP
ARG HOST_NAME
ENV HOST_NAME=$HOST_NAME

COPY ./Corefile /etc/coredns/Corefile
COPY --from=0 /config /config

# dns ports
EXPOSE 53
EXPOSE 53/udp

ENTRYPOINT ["/coredns", "-conf", "/etc/coredns/Corefile"]