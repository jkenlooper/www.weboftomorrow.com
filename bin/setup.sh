#!/usr/bin/env bash
set -eu -o pipefail

apt-get --yes update
apt-get --yes upgrade

apt-get --yes install \
  software-properties-common \
  rsync \
  nginx \
  apache2-utils \
  cron \
  curl

# Adds the `convert` command which is used to convert source-media/ images to
# the media/ directory.
apt-get --yes install imagemagick

apt-get --yes install \
  python \
  python-dev \
  python3-dev \
  python-pip \
  python-numpy \
  sqlite3 \
  libpq-dev \
  python-psycopg2 \
  virtualenv

apt-get --yes install \
  awstats
