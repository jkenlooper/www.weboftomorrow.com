#!/usr/bin/env bash

set -o errexit -o pipefail -o nounset
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
The S3 website bucket name and S3 artifact bucket name are set in the project's
.env file. A profile should also be added to ~/.aws/config file and the name of
which should be added to the .env file.
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

# Get the S3_ARTIFACT_BUCKET_NAME S3_WEBSITE_BUCKET_NAME from the .env file.
source .env

ARTIFACT_BUCKET=$S3_ARTIFACT_BUCKET_NAME
STATIC_SITE_FILES_BUCKET=$S3_WEBSITE_BUCKET_NAME
PROFILE=$AWSCONFIG_PROFILE
VERSION=$(jq -r '.version' package.json)
PROJECT_SLUG=$(jq -r '.[] | select(.ParameterKey == "ProjectSlug") | .ParameterValue' parameters.json)
GREEN_VERSION=$(jq -r '.[] | select(.ParameterKey == "GreenVersion") | .ParameterValue' parameters.json)
TMP_DIR=$(mktemp -d)
WORK_DIR=$PWD

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
diff --recursive --new-file -u --text current/ yellow/ > $TMP_DIR/static-${GREEN_VERSION}.patch || if [ $? -eq 1 ]; then echo 'Created patch file'; else echo 'failed to create patch file'; cleanup; exit 1; fi
if [ ! -s $TMP_DIR/static-${GREEN_VERSION}.patch ]; then
  echo 'no patch file created'
  cleanup
  exit 1
fi
)

du -h $TMP_DIR/static-${GREEN_VERSION}.patch

(
cd .cache/current
patch --dry-run -p1 -r - --no-backup-if-mismatch --remove-empty-files --force < $TMP_DIR/static-${GREEN_VERSION}.patch
)
read -p '
Proceed with patch? y/n ' -n 1 CONTINUE
[ "${CONTINUE}" = 'y' ] || exit 0
echo ""
echo ""
echo "Uploading patch file and starting the StaticPatch build"
echo ""

aws --profile $PROFILE s3 cp $TMP_DIR/static-${GREEN_VERSION}.patch "s3://${ARTIFACT_BUCKET}/${PROJECT_SLUG}/StaticBuild/static-${GREEN_VERSION}.patch"

# Trigger the codebuild project
aws --profile $PROFILE \
  --output json \
  --query 'build.buildStatus' \
  codebuild start-build \
  --project-name ${PROJECT_SLUG}-StaticPatch

cleanup

