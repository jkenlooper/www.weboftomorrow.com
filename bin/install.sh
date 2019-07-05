#!/usr/bin/env bash
set -eu -o pipefail

# /srv/weboftomorrow/
SRVDIR=$1

# /etc/nginx/
NGINXDIR=$2

# /var/log/nginx/weboftomorrow/
NGINXLOGDIR=$3

# /etc/systemd/system/
SYSTEMDDIR=$4

# /var/lib/weboftomorrow/sqlite3/
DATABASEDIR=$5

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
  web/default.conf web/weboftomorrow.conf "${NGINXDIR}sites-available/";
echo rsynced web/default.conf web/weboftomorrow.conf to "${NGINXDIR}sites-available/";

mkdir -p "${NGINXDIR}sites-enabled";
ln -sf "${NGINXDIR}sites-available/default.conf" "${NGINXDIR}sites-enabled/default.conf";
ln -sf "${NGINXDIR}sites-available/weboftomorrow.conf"  "${NGINXDIR}sites-enabled/weboftomorrow.conf";

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

# Create the sqlite database file if not there.
if (test ! -f "${DATABASEDIR}db"); then
    echo "Creating database from db.dump.sql"
    mkdir -p "${DATABASEDIR}"
    chown -R dev:dev "${DATABASEDIR}"
    su dev -c "sqlite3 \"${DATABASEDIR}db\" < db.dump.sql"
    chmod -R 770 "${DATABASEDIR}"
fi

mkdir -p "${SYSTEMDDIR}"
cp chill/weboftomorrow-chill.service "${SYSTEMDDIR}"
systemctl start weboftomorrow-chill || echo "can't start service"
systemctl enable weboftomorrow-chill || echo "can't enable service"
