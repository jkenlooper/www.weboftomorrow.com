#!/usr/bin/env bash
set -eu -o pipefail

COMMAND=$1

# Simple convenience script to control the apps.

# Switch out nginx www.weboftomorrow.com.conf to
# www.weboftomorrow.com--down.conf to
# show the down page.
if test "${COMMAND}" == 'start'; then
    rm -f /etc/nginx/sites-enabled/www.weboftomorrow.com--down.conf;
    ln -sf /etc/nginx/sites-available/www.weboftomorrow.com.conf /etc/nginx/sites-enabled/www.weboftomorrow.com.conf;
elif test "${COMMAND}" == 'stop'; then
    rm -f /etc/nginx/sites-enabled/www.weboftomorrow.com.conf;
    ln -sf /etc/nginx/sites-available/www.weboftomorrow.com--down.conf /etc/nginx/sites-enabled/www.weboftomorrow.com--down.conf;
fi
systemctl reload nginx;

for app in www.weboftomorrow.com-chill \
  www.weboftomorrow.com-api;
do
  echo "";
  echo "systemctl $COMMAND $app;";
  echo "----------------------------------------";
  systemctl "$COMMAND" "$app" | cat;
done;

