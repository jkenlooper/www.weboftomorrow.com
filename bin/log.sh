#!/usr/bin/env bash
set -eu -o pipefail

journalctl --follow \
  _SYSTEMD_UNIT=www.weboftomorrow.com-chill.service \
  _SYSTEMD_UNIT=www.weboftomorrow.com-api.service

