#!/bin/bash

set -euo pipefail

if test "$1"; then
    echo "creating site-data.sql for sqlite3 database: $1";
else
    echo "No db arg";
    exit 1;
fi

# Backup (site-data.sql.bak~1~ if existing) and recreate the site-data.sql
if test -e site-data.sql; then
  mv --backup=numbered site-data.sql site-data.sql.bak;
fi
{
  # Add other table data specific to the site and not included in chill-*.yaml
  # files.
  echo 'DROP TABLE if exists Document;';
  echo 'DROP TABLE if exists List;';
  echo 'DROP TABLE if exists Document_List;';
  echo '.dump Document' | sqlite3 "$1";
  echo '.dump List' | sqlite3 "$1";
  echo '.dump Document_List' | sqlite3 "$1";
} >> site-data.sql;
