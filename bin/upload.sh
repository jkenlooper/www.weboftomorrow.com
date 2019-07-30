#!/usr/bin/env bash
set -eu -o pipefail

FROZENTMP=$(mktemp -d);
tar --directory="${FROZENTMP}" --gunzip --extract -f frozen.tar.gz

aws s3 sync "${FROZENTMP}/frozen/" s3://www.weboftomorrow.com/ --profile weboftomorrow

rm -rf "${FROZENTMP}";
