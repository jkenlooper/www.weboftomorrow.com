#!/usr/bin/env bash
set -eu -o pipefail

# TODO: add usage help

FROZENTMP=$(mktemp -d);
tar --directory="${FROZENTMP}" --gunzip --extract -f frozen.tar.gz

# TODO: add bucket if not exist

# Prompt to execute the aws s3 commands
echo aws s3 sync \
  "${FROZENTMP}/frozen/" s3://www.weboftomorrow.com/ \
  --profile www.weboftomorrow.com \
  $@
echo aws s3 sync \
  root/ s3://www.weboftomorrow.com/ \
  --profile www.weboftomorrow.com \
  $@
read -p "execute commands? y/n " -n 1 CONTINUE

# Execute the aws s3 commands
if test $CONTINUE == 'y'; then
aws s3 sync \
  "${FROZENTMP}/frozen/" s3://www.weboftomorrow.com/ \
  --profile www.weboftomorrow.com \
  $@
aws s3 sync \
  root/ s3://www.weboftomorrow.com/ \
  --profile www.weboftomorrow.com \
  $@
fi

rm -rf "${FROZENTMP}";
