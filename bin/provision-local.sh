#!/bin/bash

# Run from your local machine to create certs for development.

# TODO: create the .htpasswd file
touch .htpasswd;

openssl genrsa -out web/local-www.weboftomorrow.com-CA.key 2048

openssl req -x509 -new -nodes \
  -key web/local-www.weboftomorrow.com-CA.key \
  -sha256 -days 356 \
  -config web/local-www.weboftomorrow.com-CA.cnf \
  -out web/local-www.weboftomorrow.com-CA.pem


openssl req -new -sha256 -nodes -newkey rsa:2048 \
	-config web/local-www.weboftomorrow.com.csr.cnf \
	-out web/local-www.weboftomorrow.com.csr \
	-keyout web/local-www.weboftomorrow.com.key

openssl x509 -req -CAcreateserial -days 356 -sha256 \
	-in web/local-www.weboftomorrow.com.csr \
	-CA web/local-www.weboftomorrow.com-CA.pem \
	-CAkey web/local-www.weboftomorrow.com-CA.key \
	-out web/local-www.weboftomorrow.com.crt \
	-extfile web/v3.ext


#openssl dhparam -out web/dhparam.pem 2048

# Signal that the certs should now exist.
# The web/www.weboftomorrow.com.conf.sh checks if this file exists in
# order to uncomment the lines in the nginx conf for ssl_certificate fields.
touch .has-certs web/www.weboftomorrow.com.conf.sh
