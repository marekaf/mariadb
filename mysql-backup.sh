#!/bin/bash
set -eo pipefail

if [ -z "$S3_ACCESS_KEY" -a -z "$S3_SECRET_KEY" -a -z "$S3_BUCKET_DIR" ]; then
	echo >&2 'You need to specify S3_ACCESS_KEY, S3_SECRET_KEY, S3_BUCKET_DIR'
	exit 1
fi

sed -i "s/%%S3_ACCESS_KEY%%/$S3_ACCESS_KEY/g" /root/.s3cfg
sed -i "s/%%S3_SECRET_KEY%%/$S3_SECRET_KEY/g" /root/.s3cfg

# add cron job
echo '0 2 * * * root mysqldump -u root -p$MYSQL_ROOT_PASSWORD --all-databases --force > /tmp/alldb.sql && s3cmd put /tmp/alldb.sql s3://ackee-backups/$S3_BUCKET_DIR/' >> /etc/crontab
