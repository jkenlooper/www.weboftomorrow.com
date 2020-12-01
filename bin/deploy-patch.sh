#!/usr/bin/env bash

set -o errexit -o pipefail -o nounset
set -v
GIT_STATUS=$(git diff-index --name-status HEAD)
USE_EXISTING_STATIC_ZIP=n

[ -z "${GIT_STATUS}" ] || (cat << ERROR

$GIT_STATUS

Error: The git directory is not clean. Please commit changes before running $0.

ERROR
exit 1
)


function usage {
  cat <<USAGE
Usage: ${0} [-h]
       ${0} [-f]

Options:
  -h          Show help
  -f          Use existing static.zip

Creates a patch file that will be used when updating the currently deployed
files in the S3 website bucket with what is currently commited in this git
directory. The patch file is uploaded to the S3 artifact bucket and a AWS
CodeBuild project is started to deploy the patch directly on the production
files in S3.
A profile should be added to the ~/.aws/config file and the name of which should
be added to the project's .env file. This profile should include the
'artifact_bucket' and 'staticwebsite_bucket' values.
This will create a local .cache directory which is used to store a copy of the
static site files. The aws s3 sync command is used with it.

USAGE
  exit 0;
}
while getopts ":hf" opt; do
  case ${opt} in
    h )
      usage;
      ;;
    f )
      USE_EXISTING_STATIC_ZIP=y
      ;;
  esac;
done;
shift "$((OPTIND-1))";

# Get the AWSCONFIG_PROFILE from the .env file.
source .env

PROFILE=$AWSCONFIG_PROFILE
ARTIFACT_BUCKET=$(aws configure get artifact_bucket --profile $AWSCONFIG_PROFILE)
STATIC_SITE_FILES_BUCKET=$(aws configure get asdfstaticwebsite_bucket --profile $AWSCONFIG_PROFILE)
VERSION=$(jq -r '.version' package.json)
PROJECT_SLUG=weboftomorrow
GREEN_VERSION=$(jq -r '.[] | select(.ParameterKey == "GreenVersion") | .ParameterValue' parameters.json)
TMP_DIR=$(mktemp -d)
WORK_DIR=$PWD

exit 0

cleanup() {
# Remove all files and directories in .cache except current.
find $WORK_DIR/.cache/* -maxdepth 0 ! -path $WORK_DIR/.cache/current | xargs rm -rf
rm -r $TMP_DIR
}

mkdir -p .cache
aws --profile $PROFILE s3 sync \
  s3://${STATIC_SITE_FILES_BUCKET}/${PROJECT_SLUG}/production/$GREEN_VERSION \
  .cache/current \
  --no-progress \
  --delete

[ $USE_EXISTING_STATIC_ZIP = 'n' ] && make dist
[ $USE_EXISTING_STATIC_ZIP = 'n' ] && ./bin/static.sh www.weboftomorrow.com-${VERSION}.tar.gz
unzip static.zip -d .cache

# Create the patch with the difference of current and yellow.
(
cd .cache
# diff will exit with 1 if files are different; 2 if trouble; 0 if no changes
diff --recursive --new-file -u --text current/ yellow/ > $TMP_DIR/static.patch || if [ $? -eq 1 ]; then echo 'Created patch file'; else echo 'failed to create patch file'; cleanup; exit 1; fi
if [ ! -s $TMP_DIR/static.patch ]; then
  echo 'no patch file created'
  cleanup
  exit 1
fi
)

du -h $TMP_DIR/static.patch

(
cd .cache/current
patch --dry-run -p1 -r - --no-backup-if-mismatch --remove-empty-files --force < $TMP_DIR/static.patch
)
read -p '
Proceed with patch? y/n ' -n 1 CONTINUE
[ "${CONTINUE}" = 'y' ] || exit 0
echo ""
echo ""
echo "Uploading patch file and starting the StaticPatch build"
echo ""

aws --profile $PROFILE s3 cp $TMP_DIR/static.patch "s3://${ARTIFACT_BUCKET}/${PROJECT_SLUG}/StaticBuild/static.patch"

# Trigger the codebuild project
aws --profile $PROFILE \
  --output json \
  --query 'build.buildStatus' \
  codebuild start-build \
  --project-name ${PROJECT_SLUG}-StaticPatch

cleanup

