FROM alpine:latest

ENV HOST_IP=$HOST_IP
ENV HOST_NAME=$HOST_NAME

COPY ./.zone.template /config/.zone.template

# create dns zone from template
RUN apk add gettext && envsubst '${HOST_IP} ${HOST_NAME}' < /config/.zone.template > /config/.zone

FROM coredns/coredns:1.9.4

ENV HOST_IP=$HOST_IP
ENV HOST_NAME=$HOST_NAME

COPY ./Corefile /etc/coredns/Corefile
COPY --from=0 /config /config

# change config path
ENTRYPOINT ["/coredns", "-conf", "/etc/coredns/Corefile"]