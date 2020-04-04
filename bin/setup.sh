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
