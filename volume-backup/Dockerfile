FROM offen/docker-volume-backup:v2.22.2

# https://github.com/offen/docker-volume-backup#configuration-reference
ENV BACKUP_FILENAME="%Y-%m-%d_%H.%M.%S.tar.gz"
ENV BACKUP_LATEST_SYMLINK="main.tar.gz"
ARG BACKUP_RETENTION_DAYS="7"
ENV BACKUP_RETENTION_DAYS=$BACKUP_RETENTION_DAYS
# backup at 03:00 every day
ARG BACKUP_CRON_EXPRESSION="0 3 * * *"
ENV BACKUP_CRON_EXPRESSION=$BACKUP_CRON_EXPRESSION

ENTRYPOINT ["/root/entrypoint.sh"]