FROM alpine:3.17.0

# run at 00:00 every day
ARG DIFFERENTIAL_BACKUP_CRON="0 0 * * *"
ARG DIFFERENTIAL_BACKUP_RETENTION="30"

# run at 00:00 every week (on sunday)
ARG FULL_BACKUP_CRON="0 0 * * 0"
ARG FULL_BACKUP_RETENTION="7"

# run at 00:00 every week (on sunday)
ARG REMOTE_BACKUP_CRON="0 0 * * 0"
ARG REMOTE_BACKUP_RETENTION="7"
ARG REMOTE_BACKUP_PASSPHRASE=""

ENV DIFFERENTIAL_BACKUP_CRON=$DIFFERENTIAL_BACKUP_CRON
ENV DIFFERENTIAL_BACKUP_RETENTION=$DIFFERENTIAL_BACKUP_RETENTION

ENV FULL_BACKUP_CRON=$FULL_BACKUP_CRON
ENV FULL_BACKUP_RETENTION=$FULL_BACKUP_RETENTION

ENV REMOTE_BACKUP_CRON=$REMOTE_BACKUP_CRON
ENV REMOTE_BACKUP_RETENTION=$REMOTE_BACKUP_RETENTION
ENV REMOTE_BACKUP_PASSPHRASE=$REMOTE_BACKUP_PASSPHRASE

RUN apk add rdiff-backup tar gpg gpg-agent rclone openssh-client docker gettext

COPY backup.cron.template /etc/cron.d/backup.cron.template
COPY --chmod=0755 differential-backup.sh /usr/local/bin/differential-backup.sh
COPY --chmod=0755 full-backup.sh /usr/local/bin/full-backup.sh
COPY --chmod=0755 remote-backup.sh /usr/local/bin/remote-backup.sh
COPY rclone.conf /root/.config/rclone/rclone.conf

# adding backup scripts to path for better access
ENV PATH="$PATH:/usr/local/bin"

# replace envs in cron file
RUN envsubst < /etc/cron.d/backup.cron.template > /etc/cron.d/backup.cron

CMD ["crond", "-f"]
