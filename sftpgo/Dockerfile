FROM drakkan/sftpgo:v2.4.2

# https://github.com/drakkan/sftpgo/blob/main/sftpgo.json
ENV SFTPGO_HTTPD__BINDINGS__0__PORT="9200"
ENV SFTPGO_WEBDAVD__BINDINGS__0__PORT="9400"
ENV SFTPGO_SFTPD__BINDINGS__0__PORT="9600"
ENV SFTPGO_LOADDATA_FROM="/etc/sftpgo/init.json"

COPY ./init.json /etc/sftpgo/init.json

# root user is temporary needed for installing packages
USER root
RUN  apt-get update && apt-get install -y curl
USER 1000:1000

HEALTHCHECK  --interval=60s --timeout=10s --retries=3 \
  CMD curl --fail http://localhost:9200/healthz || exit 1

# web interface
EXPOSE 9200

# webdav
EXPOSE 9400

# sftp
EXPOSE 9600

CMD ["sftpgo", "serve"]