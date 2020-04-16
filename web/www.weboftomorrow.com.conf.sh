#!/usr/bin/env bash

set -eu -o pipefail

ENVIRONMENT=$1
SRVDIR=$2
NGINXLOGDIR=$3
PORTREGISTRY=$4
INTERNALIP=$5

# shellcheck source=/dev/null
source "$PORTREGISTRY"

DATE=$(date)

# Load snippet confs
file_ssl_params_conf=$(cat web/ssl_params.conf)

cat <<HERE
# File generated from $0
# on ${DATE}

# https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#server-name-if
server {
  listen 80;
  listen 443 ssl http2;
  server_tokens off;
HERE
if test $ENVIRONMENT == 'development'; then
cat <<HEREBEDEVELOPMENT
  # Redirect other domains (in development uses 302 temporary redirect)
  server_name local-weboftomorrow.com;
  return       302 \$scheme://local-www.weboftomorrow.com\$request_uri;
HEREBEDEVELOPMENT
else
cat <<HEREBEPRODUCTION
  # Permanent redirect other domains (production uses 301 for permanent)
  server_name weboftomorrow.com;
  return       301 \$scheme://www.weboftomorrow.com\$request_uri;
HEREBEPRODUCTION
fi
cat <<HERE
}

server {
  listen 80;
  listen 443 ssl http2;
  server_tokens off;

  ${file_ssl_params_conf}

  add_header X-Frame-Options DENY;
  add_header X-Content-Type-Options nosniff;

  root ${SRVDIR}root;

  access_log  ${NGINXLOGDIR}access.log;
  error_log   ${NGINXLOGDIR}error.log;

  error_page 404 /notfound.html;
  location = /notfound.html {
    internal;
  }

  error_page 500 501 502 504 505 506 507 /error.html;
  location = /error.html {
    internal;
  }

  location = /humans.txt {}
  location = /robots.txt {}
  location = /favicon.ico {}

HERE

if (test -f web/dhparam.pem); then
cat <<HERE
  ## Danger Zone.  Only uncomment if you know what you are doing.
  #ssl_dhparam /etc/nginx/ssl/dhparam.pem;
HERE
fi

if test $ENVIRONMENT == 'development'; then

if test -e .has-certs; then
cat <<HEREENABLESSLCERTS
  # certs created for local development
  ssl_certificate /etc/ssl/certs/local-www.weboftomorrow.com.crt;
  ssl_certificate_key /etc/ssl/private/local-www.weboftomorrow.com.key;
HEREENABLESSLCERTS
else
cat <<HERETODOSSLCERTS
  # certs for local development can be created by running './bin/provision-local-ssl-certs.sh'
  # uncomment after they exist (run make again)
  #ssl_certificate /etc/ssl/certs/local-www.weboftomorrow.com.crt;
  #ssl_certificate_key /etc/ssl/private/local-www.weboftomorrow.com.key;
HERETODOSSLCERTS
fi

cat <<HEREBEDEVELOPMENT

  # Only when in development should the site be accessible via internal ip.
  # This makes it easier to test with other devices that may not be able to
  # update a /etc/hosts file.
  server_name local-www.weboftomorrow.com $INTERNALIP;

  # It is useful to have chill run in dev mode when editing templates. Note
  # that in production it uses the static pages (frozen).
  location / {
    proxy_pass_header Server;
    proxy_set_header Host \$http_host;
    proxy_set_header  X-Real-IP  \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

    proxy_redirect off;
    proxy_intercept_errors on;
    proxy_pass http://localhost:${PORTCHILL};
  }
HEREBEDEVELOPMENT

else

if test -e .has-certs; then
cat <<HEREENABLESSLCERTS
  # certs created from certbot
  ssl_certificate /etc/letsencrypt/live/www.weboftomorrow.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/www.weboftomorrow.com/privkey.pem;
HEREENABLESSLCERTS
else
cat <<HERETODOSSLCERTS
  # certs can be created from running 'bin/provision-certbot.sh ${SRVDIR}'
  # TODO: uncomment after they exist
  #ssl_certificate /etc/letsencrypt/live/www.weboftomorrow.com/fullchain.pem;
  #ssl_certificate_key /etc/letsencrypt/live/www.weboftomorrow.com/privkey.pem;
HERETODOSSLCERTS
fi

cat <<HEREBEPRODUCTION

  # Support blue-green deployments.
  server_name www.weboftomorrow.com-blue www.weboftomorrow.com-green www.weboftomorrow.com;

  location /.well-known/ {
    try_files \$uri =404;
  }

  location / {
    root ${SRVDIR}frozen;
  }
HEREBEPRODUCTION
fi

cat <<HERE
}
HERE
