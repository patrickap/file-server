FROM offen/docker-volume-backup:v2.22.2

# backup at 03:00 every day
ARG CRON_EXPRESSION="0 3 * * *"
ARG RETENTION_DAYS="7"

# https://github.com/offen/docker-volume-backup#configuration-reference
ENV BACKUP_CRON_EXPRESSION=$CRON_EXPRESSION
ENV BACKUP_RETENTION_DAYS=$RETENTION_DAYS
ENV BACKUP_FILENAME="%Y-%m-%d_%H.%M.%S.tar.gz"
ENV BACKUP_LATEST_SYMLINK="main.tar.gz"

ENTRYPOINT ["/root/entrypoint.sh"]