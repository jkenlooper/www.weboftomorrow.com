#!/usr/bin/env bash
set -eu -o pipefail

FROZEN_TAR=$1

# Create a tmp db from db.dump.sql and tmp site.cfg to use the temporary
# database.
sed "/^CHILL_DATABASE_URI/ s/sqlite:\/\/\/.*db/sqlite:\/\/\/tmpdb/" site.cfg > tmpsite.cfg
sqlite3 tmpdb < db.dump.sql

bin/chill freeze --config tmpsite.cfg
cp frozen/site/index.html frozen/

# Remove no longer needed temporary files.
rm -f tmpdb tmpsite.cfg;

tar --create --auto-compress --file "${FROZEN_TAR}" frozen/

# Remove frozen files that were generated since the tar should be used to
# install.
rm -rf frozen
