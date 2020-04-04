#!/usr/bin/env bash

set -eu -o pipefail
shopt -s extglob

# Uninstall and clean up script

# /srv/www.weboftomorrow.com/
SRVDIR=$1

# /etc/nginx/
NGINXDIR=$2

# /etc/systemd/system/
SYSTEMDDIR=$3

# /var/lib/www.weboftomorrow.com/sqlite3/
DATABASEDIR=$4

rm -rf ${SRVDIR}root/!(.well-known|.|..)

rm -rf "${SRVDIR}frozen/"

rm -f "${NGINXDIR}sites-enabled/www.weboftomorrow.com.conf";
rm -f "${NGINXDIR}sites-available/www.weboftomorrow.com.conf";
rm -f "${NGINXDIR}sites-enabled/www.weboftomorrow.com--down.conf";
rm -f "${NGINXDIR}sites-available/www.weboftomorrow.com--down.conf";

rm -f "${SRVDIR}.htpasswd";

rm -f /etc/cron.d/awstats-www.weboftomorrow.com-crontab
# Stop and start in order for the crontab to be loaded (reload not supported).
systemctl stop cron && systemctl start cron || echo "Can't reload cron service"

rm -f /etc/awstats/awstats.www.weboftomorrow.com.conf

systemctl stop www.weboftomorrow.com-chill
systemctl disable www.weboftomorrow.com-chill
rm -f "${SYSTEMDDIR}www.weboftomorrow.com-chill.service";

systemctl stop www.weboftomorrow.com-api
systemctl disable www.weboftomorrow.com-api
rm -f "${SYSTEMDDIR}www.weboftomorrow.com-api.service";

# TODO: Should it remove the database file in an uninstall?
echo "Skipping removal of sqlite database file ${DATABASEDIR}db"
#rm -f "${DATABASEDIR}db"

exit
