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

cat <<HERE
# File generated from $0
# on ${DATE}

server {
  listen 80;
  listen 443 ssl http2;
  server_tokens off;


  ## SSL Params
  # from https://cipherli.st/
  # and https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html
  # SSL Decoder https://ssldecoder.org/

  ## Danger Zone.  Only uncomment if you know what you are doing.
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_prefer_server_ciphers on;
  ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
  ssl_ecdh_curve secp384r1;
  ssl_session_cache shared:SSL:10m;
  ssl_session_tickets off;
  #ssl_stapling on;
  #ssl_stapling_verify on;
  resolver 8.8.8.8 8.8.4.4 valid=300s;
  resolver_timeout 5s;
  # Disable preloading HSTS for now.  You can use the commented out header line that includes
  # the "preload" directive if you understand the implications.
  #add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
  #add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";
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

  location / {
    try_files \$uri \$uri =404;
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

  # TODO: Decide if static site should be down when updating.
  location / {
    root ${SRVDIR}frozen;
  }
HEREBEPRODUCTION
fi

cat <<HERE
}
HERE

