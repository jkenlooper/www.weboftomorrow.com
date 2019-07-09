#!/bin/bash

if test "$1"; then
    echo "creating chill-data.sql for sqlite3 database: $1";
else
    echo "No db arg";
    exit 1;
fi

# Recreate the chill-data.sql which is used to update database


echo 'DROP TABLE if exists Node;' >> chill-data.sql
echo 'DROP TABLE if exists Node_Node;' >> chill-data.sql
echo 'DROP TABLE if exists Query;' >> chill-data.sql
echo 'DROP TABLE if exists Route;' >> chill-data.sql
echo 'DROP TABLE if exists Template;' >> chill-data.sql

echo 'DROP TABLE if exists Chill;' > chill-data.sql
echo 'DROP TABLE if exists Document;' >> chill-data.sql
echo 'DROP TABLE if exists List;' >> chill-data.sql
echo 'DROP TABLE if exists Document_List;' >> chill-data.sql

# Chill Node data is saved in chill-data.yaml and only the create tables is
# needed in chill-data.sql.
chill dump --yaml chill-data.yaml
echo '.schema --indent Node' | sqlite3 "$1" >> chill-data.sql
echo '.schema --indent Node_Node' | sqlite3 "$1" >> chill-data.sql
echo '.schema --indent Query' | sqlite3 "$1" >> chill-data.sql
echo '.schema --indent Route' | sqlite3 "$1" >> chill-data.sql
echo '.schema --indent Template' | sqlite3 "$1" >> chill-data.sql

# Dump other tables not covered by the chill dump script
echo '.dump Chill' | sqlite3 "$1" >> chill-data.sql
echo '.dump Document' | sqlite3 "$1" >> chill-data.sql
echo '.dump List' | sqlite3 "$1" >> chill-data.sql
echo '.dump Document_List' | sqlite3 "$1" >> chill-data.sql
