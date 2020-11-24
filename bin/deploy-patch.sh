#!/usr/bin/env bash

set -o errexit -o pipefail -o nounset

ARTIFACT_BUCKET=$1
STATIC_SITE_FILES_BUCKET=$2
VERSION=$(jq -r '.version' package.json)
PROJECT_SLUG=$(jq -r '.[] | select(.ParameterKey == "ProjectSlug") | .ParameterValue' parameters.json)
GREEN_VERSION=$(jq -r '.[] | select(.ParameterKey == "GreenVersion") | .ParameterValue' parameters.json)


mkdir -p .cache
aws --profile artifact-pusher s3 sync \
  s3://${STATIC_SITE_FILES_BUCKET}/${PROJECT_SLUG}/production/$GREEN_VERSION \
  .cache/current \
  --no-progress \
  --delete

make dist
./bin/static.sh www.weboftomorrow.com-${VERSION}.tar.gz
unzip static.zip -d .cache


(
cd .cache
# diff will exit with 1 if files are different; 2 if trouble; 0 if no changes
rm -f ../static-${GREEN_VERSION}.patch
diff --recursive --new-file -u -a current/ yellow/ > ../static-${GREEN_VERSION}.patch || if [ $? -eq 1 ]; then echo 'Created patch file'; else echo 'failed to create patch file'; exit 1; fi
if [ ! -s ../static-${GREEN_VERSION}.patch ]; then
  echo 'no patch file created'
  # patch file can also be empty so remove it
  rm -f ../static-${GREEN_VERSION}.patch
  exit 1
fi
)

aws --profile artifact-pusher s3 cp static-${GREEN_VERSION}.patch "s3://${ARTIFACT_BUCKET}/${PROJECT_SLUG}/StaticBuild/static-${GREEN_VERSION}.patch"

# Trigger the codebuild project
aws --profile artifact-pusher \
  --output json \
  --query 'build.buildStatus' \
  codebuild start-build \
  --project-name ${PROJECT_SLUG}-StaticPatch

