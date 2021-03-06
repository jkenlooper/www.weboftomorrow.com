#!/usr/bin/env bash
set -o errexit -o pipefail

# Allow NVM_DIR to not be set
#-o nounset

# Create a distribution for uploading to a production server.

# archive file path should be absolute
ARCHIVE=$1

TMPDIR=$(mktemp --directory);

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || echo 'No nvm found'  # This conditionally loads nvm
nvm --version || echo 'skipping use of nvm'

git clone --recurse-submodules . "$TMPDIR";

(
cd "$TMPDIR";

# Use the node and npm that is set in .nvmrc
nvm use || echo 'skipping use of nvm'

# Build
npm ci; # clean install
npm run build;

# Create symlinks for all files in the MANIFEST.
mkdir -p www.weboftomorrow.com;
for item in $(cat MANIFEST); do
  dirname "www.weboftomorrow.com/${item}" | xargs mkdir -p;
  dirname "www.weboftomorrow.com/${item}" | xargs ln -sf "${PWD}/${item}";
done;

tar --dereference \
  --exclude=MANIFEST \
  --create \
  --auto-compress \
  --file "${ARCHIVE}" www.weboftomorrow.com;
)

# Clean up
rm -rf "${TMPDIR}";
