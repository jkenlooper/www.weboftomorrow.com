#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

function usage {
  cat <<USAGE
Usage: ${0} [-h]

Options:
  -h            Show help

Creates the .env file used for setting some configuration for the website.
Existing files will be renamed with a .bak suffix.
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

read -p "
Name of the aws configure profile (in $HOME/.aws/config) to use for the site:
" AWSCONFIG_PROFILE;
[ ! -z $AWSCONFIG_PROFILE ]
echo ""

if [ -f .env ]; then
  mv --backup=numbered .env .env.bak
fi

(
cat <<HERE

# Any changes to this .env should also match changes in the buildspec.yml. Note
# that the buildspec.yml uses parameter-store for any variables that should not
# be committed to version control.

# Example purposes only.
EXAMPLE_PUBLIC_KEY=fill-this-in
EXAMPLE_SECRET_KEY=fill-this-in

# This profile will be used for aws cli commands.
AWSCONFIG_PROFILE=$AWSCONFIG_PROFILE

HERE
) > .env

read -p "
Name of S3 bucket to use for artifacts:
" S3_ARTIFACT_BUCKET_NAME
[ ! -z $S3_ARTIFACT_BUCKET_NAME ]
aws configure set artifact_bucket $S3_ARTIFACT_BUCKET_NAME --profile $AWSCONFIG_PROFILE

read -p "
Name of S3 bucket to use for static website hosting:
" S3_WEBSITE_BUCKET_NAME
[ ! -z $S3_WEBSITE_BUCKET_NAME ]
aws configure set staticwebsite_bucket $S3_WEBSITE_BUCKET_NAME --profile $AWSCONFIG_PROFILE

echo "Created .env file with the below contents:"
echo ""
cat .env
echo ""
