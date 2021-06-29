#!/bin/sh

#
# ORIGINAL AUTHOR: Remy Leone https://github.com/remyleone/scw-s3-action
#

set -euo pipefail

: "${INPUT_S3_ACCESS_KEY?INPUT_S3_ACCESS_KEY environment variable must be set}"
: "${INPUT_S3_SECRET_KEY?INPUT_S3_SECRET_KEY environment variable must be set}"
: "${INPUT_S3_ENDPOINT?INPUT_S3_ENDPOINT environment variable must be set. Ex: s3.fr-par.scw.cloud}"
: "${INPUT_S3_REGION?INPUT_S3_REGION environment variable must be set. Ex: fr-par}"
: "${INPUT_BUCKET_NAME?INPUT_BUCKET_NAME environment variable must be set}"
: "${INPUT_WEBSITE_CONFIG_PATH?INPUT_WEBSITE_CONFIG_PATH environment variable must be set. Should be path from root project.}"
: "${INPUT_BUCKET_POLICY_CONFIG_PATH?INPUT_BUCKET_POLICY_CONFIG_PATH environment variable must be set. Should be path from root project.}"
: "${INPUT_SOURCE_DIRECTORY?INPUT_SOURCE_DIRECTORY environment variable must be set. Should be path from root project of the directory you want to sync with s3 bucket.}"
: "${INPUT_SYNC_ARGS?INPUT_SYNC_ARGS environment variable must be set. If you do not want to set any args please set an empty string.}"

mkdir -p ~/.aws

touch ~/.aws/config

echo "
[plugins]
endpoint = awscli_plugin_endpoint

[default]
region = ${INPUT_S3_REGION}
s3 =
  endpoint_url = https://${INPUT_S3_ENDPOINT}
  signature_version = s3v4
s3api =
  endpoint_url = https://${INPUT_S3_ENDPOINT}
" > ~/.aws/config

touch ~/.aws/credentials

echo "[default]
aws_access_key_id = ${INPUT_S3_ACCESS_KEY}
aws_secret_access_key = ${INPUT_S3_SECRET_KEY}" > ~/.aws/credentials

echo "Trying to create bucket..."

set +e
aws s3 mb s3://"${INPUT_BUCKET_NAME}"

if [ $? -eq 0 ]; then
    echo "Bucket created!"
else
    echo "Bucket already created."
fi

echo "Applying bucket website config and policy..."
aws s3api put-bucket-website --bucket "${INPUT_BUCKET_NAME}" --website-configuration file://"${INPUT_WEBSITE_CONFIG_PATH}"
sed -e "s/BUCKET_NAME/${INPUT_BUCKET_NAME}/g" "${INPUT_BUCKET_POLICY_CONFIG_PATH}" > bucket-policy.json
aws s3api put-bucket-policy --bucket "${INPUT_BUCKET_NAME}" --policy file://./bucket-policy.json


echo "Starting sync..."
aws s3 sync "${INPUT_SOURCE_DIRECTORY}" s3://"${INPUT_BUCKET_NAME}" "${INPUT_SYNC_ARGS}"
