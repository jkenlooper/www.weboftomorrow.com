#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

function usage {
  cat <<USAGE
Usage: ${0} [-h]

Options:
  -h            Show help

Wraps the rsync command to upload files (SRC...) to a destination (DEST). It
defaults the SRC to the current directory (.) and the DEST to
dev@local-www.weboftomorrow.com:/usr/local/src/www.weboftomorrow.com/ which
local-www.weboftomorrow.com should be the local machine being used for development.

Only includes the files listed in the MANIFEST file.
USAGE
  exit 0;
}

while getopts ":h" opt; do
  case ${opt} in
    h )
      usage;
      ;;
    \? )
      usage;
      ;;
  esac;
done;
shift "$((OPTIND-1))";

which rsync > /dev/null || (echo "No rsync command found. Install rsync." && exit 1)

# Use --delay-updates to put files into place at the end. This way any file
# watching on the virtual machine end won't be triggered prematurely.

# Use --include-from and --relative options to include only the files listed in
# the MANIFEST. Also using the --exclude options as a precaution to not include
# specific files and directories that don't need to be transferred.

rsync --archive \
  --delay-updates \
  --itemize-changes \
  --relative \
  --recursive \
  --copy-links \
  --files-from=MANIFEST \
  --exclude=.git \
  --exclude=.vagrant \
  --exclude=node_modules \
  --exclude=package-lock.json \
  . dev@local-www.weboftomorrow.com:/usr/local/src/www.weboftomorrow.com/

# Include any other files that are not part of the MANIFEST, but are created on
# the local machine.
rsync --archive \
  --delay-updates \
  --itemize-changes \
  .env \
  .htpasswd \
  dev@local-www.weboftomorrow.com:/usr/local/src/www.weboftomorrow.com/

rsync --archive \
  --delay-updates \
  --itemize-changes \
  --relative \
  bin/dist.sh \
  bin/deploy.sh \
  bin/static.sh \
  dev@local-www.weboftomorrow.com:/usr/local/src/www.weboftomorrow.com/

