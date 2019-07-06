#!/usr/bin/env bash

ENVIRONMENT=$1
SRCDIR=$2

DATE=$(date)

cat <<HERE

# File generated from $0
# on ${DATE}

[Unit]
Description=Chill weboftomorrow instance
After=network.target

[Service]
User=dev
Group=dev
WorkingDirectory=$SRCDIR
HERE
if test "${ENVIRONMENT}" == 'development'; then
echo "ExecStart=${SRCDIR}bin/chill run"
else
echo "ExecStart=${SRCDIR}bin/chill serve"
fi
cat <<HERE

[Install]
WantedBy=multi-user.target

HERE
