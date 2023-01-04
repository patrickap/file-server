FROM drakkan/sftpgo:v2.4.2

ARG SFTPGO_LOG_LEVEL="info"

# https://github.com/drakkan/sftpgo/blob/main/sftpgo.json
ENV SFTPGO_LOG_LEVEL=$SFTPGO_LOG_LEVEL
ENV SFTPGO_HTTPD__BINDINGS__0__PORT="9200"
ENV SFTPGO_WEBDAVD__BINDINGS__0__PORT="9400"
ENV SFTPGO_SFTPD__BINDINGS__0__PORT="9600"

# TODO: enable the following for an experimental trash implementation
# ENV SFTPGO_COMMON__ACTIONS__EXECUTE_ON="pre-delete"
# ENV SFTPGO_COMMON__ACTIONS__HOOK="/var/lib/sftpgo/trash_action.sh"
# COPY --chmod=0755 ./trash_action.sh /var/lib/sftpgo/trash_action.sh

COPY ./init.json /var/lib/sftpgo/init.json

# root user is temporary needed for installing packages
USER root
RUN  apt-get update && apt-get install -y curl
# reset to default sftpgo user
USER 1000:1000

HEALTHCHECK  --interval=60s --timeout=10s --retries=3 \
  CMD curl --fail http://localhost:9200/healthz || exit 1

# web ui
EXPOSE 9200

# webdav
EXPOSE 9400

# sftp
EXPOSE 9600

# start server and initialize using an init file
CMD ["sftpgo", "serve", "--loaddata-from", "/var/lib/sftpgo/init.json"]