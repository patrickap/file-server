FROM offen/docker-volume-backup:v2.24.0

ARG BACKUP_FILENAME="backup-%Y-%m-%d_%H.%M.%S.tar.gz"
# run at 00:00 every day
ARG BACKUP_CRON_EXPRESSION="0 0 * * *"
ARG BACKUP_PRUNING_PREFIX="backup-"
# remove backups older than 7 days
ARG BACKUP_RETENTION_DAYS="7"
# optional gpg passphrase to encrypt backups
ARG GPG_PASSPHRASE
# optional label for fine grained control over lifecycle hook execution
ARG EXEC_LABEL

# https://github.com/offen/docker-volume-backup#configuration-reference
ENV BACKUP_FILENAME=$BACKUP_FILENAME
ENV BACKUP_CRON_EXPRESSION=$BACKUP_CRON_EXPRESSION
ENV BACKUP_PRUNING_PREFIX=$BACKUP_PRUNING_PREFIX
ENV BACKUP_RETENTION_DAYS=$BACKUP_RETENTION_DAYS
ENV GPG_PASSPHRASE=$GPG_PASSPHRASE
ENV EXEC_LABEL=$EXEC_LABEL

RUN apk add rclone

ENTRYPOINT ["/root/entrypoint.sh"]