#!/usr/bin/env bash
set -o errexit -o pipefail
# Not using nounset. The $1 arg is checked manually when setting STATIC_FILE.
#set -o nounset

function usage {
  cat <<USAGE
Usage: ${0} [-h] [static.tar.gz] [other options for aws s3]

Options:
  -h          Show help

Wrapper around aws s3 sync command. Takes the contents from a static.tar.gz and
uploads them to s3 bucket.

USAGE
  exit 0;
}
while getopts ":h" opt; do
  case ${opt} in
    h )
      usage;
      ;;
  esac;
done;
shift "$((OPTIND-1))";

if test -z $1; then
  echo "Missing static archive file arg";
  exit 1;
fi

STATIC_FILE=$1
# Pass any other options except the STATIC_FILE arg to aws s3 command.
AWS_OPTS=${@#${STATIC_FILE}}

TMP_STATIC_DIR=$(mktemp -d);
tar --directory=${TMP_STATIC_DIR} --extract --gunzip -f ${STATIC_FILE}

# TODO: add bucket if not exist

# Prompt to execute the aws s3 commands
echo aws s3 sync \
  ${TMP_STATIC_DIR}/ s3://www.weboftomorrow.com/ \
  --profile www.weboftomorrow.com \
  $AWS_OPTS
read -p "execute deploy command? y/n " -n 1 CONTINUE

# Execute the aws s3 commands
if test $CONTINUE == 'y'; then
aws s3 sync \
  ${TMP_STATIC_DIR}/ s3://www.weboftomorrow.com/ \
  --profile www.weboftomorrow.com \
  $AWS_OPTS
fi

rm -rf "${TMP_STATIC_DIR}";
