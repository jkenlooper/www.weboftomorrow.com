#!/usr/bin/env bash
set -o errexit -o pipefail
# Not using nounset. The $1 arg is checked manually when setting DIST_FILE.
#set -o nounset

function usage {
  cat <<USAGE
Usage: ${0} [-h] [dist_file.tar.gz]

Options:
  -h          Show help

Creates a static.zip from the dist file. The top level directory in
the archive will have the version as the name.

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
  echo "Missing dist file arg";
  exit 1;
fi

DIST_FILE=$1

TMP_SRC_DIR=$(mktemp -d);
tar --directory=${TMP_SRC_DIR} --strip 1 --extract --gunzip -f ${DIST_FILE}
touch .env
touch .htpasswd
cp .env ${TMP_SRC_DIR};
cp .htpasswd ${TMP_SRC_DIR};

WORKING_DIR=$(pwd);

(
cd ${TMP_SRC_DIR};
python3 -m venv .
source bin/activate;
TAG=$(make inspect.TAG)
make ENVIRONMENT=production;

tar --directory=./ --gunzip --extract -f frozen.tar.gz

TMP_STATIC_DIR=$(mktemp -d);
shopt -s dotglob nullglob
mkdir ${TMP_STATIC_DIR}/${TAG}
mv frozen/* ${TMP_STATIC_DIR}/${TAG}
mv root/* ${TMP_STATIC_DIR}/${TAG}
# The yellow directory is used when syncing to the green version
mv ${TMP_STATIC_DIR}/${TAG} ${TMP_STATIC_DIR}/yellow

(
cd ${TMP_STATIC_DIR}
rm -f ${WORKING_DIR}/static.zip
zip -r ${WORKING_DIR}/static.zip .
)

rm -rf "${TMP_STATIC_DIR}";

deactivate;
)

rm -rf "${TMP_SRC_DIR}";
