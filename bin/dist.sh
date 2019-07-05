#!/usr/bin/env bash
set -eu -o pipefail

# Create a distribution for uploading to a production server.

# archive file path should be absolute
ARCHIVE=$1

TMPDIR=$(mktemp --directory);

git clone . "$TMPDIR";

(
cd "$TMPDIR";

# Create symlinks for all files in the MANIFEST.
for item in $(cat weboftomorrow/MANIFEST); do
  dirname "weboftomorrow/${item}" | xargs mkdir -p;
  dirname "weboftomorrow/${item}" | xargs ln -sf "${PWD}/${item}";
done;

tar --dereference \
  --exclude=MANIFEST \
  --create \
  --auto-compress \
  --file "${ARCHIVE}" weboftomorrow;
)

# Clean up
rm -rf "${TMPDIR}";
