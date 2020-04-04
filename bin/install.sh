#!/usr/bin/env bash
set -eu -o pipefail

# /srv/www.weboftomorrow.com/
SRVDIR=$1

# /etc/nginx/
NGINXDIR=$2

# /var/log/nginx/www.weboftomorrow.com/
NGINXLOGDIR=$3

# /var/log/awstats/www.weboftomorrow.com/
AWSTATSLOGDIR=$4

# /etc/systemd/system/
SYSTEMDDIR=$5

# /var/lib/www.weboftomorrow.com/sqlite3/
DATABASEDIR=$6

mkdir -p "${SRVDIR}root/";
#chown -R dev:dev "${SRVDIR}root/";
rsync --archive \
  --inplace \
  --delete \
  --exclude=.well-known \
  --itemize-changes \
  root/ "${SRVDIR}root/";
echo "rsynced files in root/ to ${SRVDIR}root/";

FROZENTMP=$(mktemp -d);
tar --directory="${FROZENTMP}" --gunzip --extract -f frozen.tar.gz
rsync --archive \
  --delete \
  --itemize-changes \
  "${FROZENTMP}/frozen/" "${SRVDIR}frozen/";
echo "rsynced files in frozen.tar.gz to ${SRVDIR}frozen/";
rm -rf "${FROZENTMP}";

mkdir -p "${NGINXLOGDIR}";

# Run rsync checksum on nginx default.conf since other sites might also update
# this file.
mkdir -p "${NGINXDIR}sites-available"
rsync --inplace \
  --checksum \
  --itemize-changes \
  web/default.conf web/www.weboftomorrow.com.conf web/www.weboftomorrow.com--down.conf "${NGINXDIR}sites-available/";
echo rsynced web/default.conf web/www.weboftomorrow.com.conf web/www.weboftomorrow.com--down.conf to "${NGINXDIR}sites-available/";

mkdir -p "${NGINXDIR}sites-enabled";
ln -sf "${NGINXDIR}sites-available/default.conf" "${NGINXDIR}sites-enabled/default.conf";

rm -f "${NGINXDIR}sites-enabled/www.weboftomorrow.com--down.conf"
ln -sf "${NGINXDIR}sites-available/www.weboftomorrow.com.conf"  "${NGINXDIR}sites-enabled/www.weboftomorrow.com.conf";

rsync --inplace \
  --checksum \
  --itemize-changes \
  .htpasswd "${SRVDIR}";

if (test -f web/dhparam.pem); then
mkdir -p "${NGINXDIR}ssl/"
rsync --inplace \
  --checksum \
  --itemize-changes \
  web/dhparam.pem "${NGINXDIR}ssl/dhparam.pem";
fi
if (test -f web/local-www.weboftomorrow.com.crt); then
mkdir -p "${NGINXDIR}ssl/"
rsync --inplace \
  --checksum \
  --itemize-changes \
  web/local-www.weboftomorrow.com.crt "${NGINXDIR}ssl/local-www.weboftomorrow.com.crt";
fi
if (test -f web/local-www.weboftomorrow.com.key); then
mkdir -p "${NGINXDIR}ssl/"
rsync --inplace \
  --checksum \
  --itemize-changes \
  web/local-www.weboftomorrow.com.key "${NGINXDIR}ssl/local-www.weboftomorrow.com.key";
fi

# Create the root directory for stats. The awstats icons will be placed there.
mkdir -p "${SRVDIR}stats"

if (test -d /usr/share/awstats/icon); then
rsync --archive \
  --inplace \
  --checksum \
  --itemize-changes \
  /usr/share/awstats/icon "${SRVDIR}stats/";
fi

mkdir -p "${AWSTATSLOGDIR}"

# Add crontab file in the cron directory
cp stats/awstats-www.weboftomorrow.com-crontab /etc/cron.d/
chmod 0644 /etc/cron.d/awstats-www.weboftomorrow.com-crontab
# Stop and start in order for the crontab to be loaded (reload not supported).
systemctl stop cron && systemctl start cron || echo "Can't reload cron service"

# Add the awstats conf
cp stats/awstats.www.weboftomorrow.com.conf /etc/awstats/

# Set the sqlite database file from the db.dump.sql.
echo "Setting Chill database tables from db.dump.sql"
mkdir -p "${DATABASEDIR}"
chown -R dev:dev "${DATABASEDIR}"
su dev -c "sqlite3 \"${DATABASEDIR}db\" < db.dump.sql"
# Need to set Write-Ahead Logging so multiple apps can work with the db
# concurrently.  https://sqlite.org/wal.html
su dev -c "echo \"pragma journal_mode=wal\" | sqlite3 ${DATABASEDIR}db"
chmod -R 770 "${DATABASEDIR}"

mkdir -p "${SYSTEMDDIR}"
cp chill/www.weboftomorrow.com-chill.service "${SYSTEMDDIR}"
systemctl start www.weboftomorrow.com-chill || echo "can't start service"
systemctl enable www.weboftomorrow.com-chill || echo "can't enable service"

cp api/www.weboftomorrow.com-api.service "${SYSTEMDDIR}"
systemctl start www.weboftomorrow.com-api || echo "can't start service"
systemctl enable www.weboftomorrow.com-api || echo "can't enable service"
