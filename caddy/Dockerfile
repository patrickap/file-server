FROM caddy:2.6.2

ARG HOST_IP
ENV HOST_IP=$HOST_IP
ARG HOST_NAME
ENV HOST_NAME=$HOST_NAME

COPY ./Caddyfile /etc/caddy/Caddyfile

# http / https ports
EXPOSE 80
EXPOSE 443
EXPOSE 443/udp

# admin endpoint
EXPOSE 2019

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]