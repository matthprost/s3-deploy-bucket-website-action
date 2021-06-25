#!/bin/sh

#
# ORIGINAL AUTHOR: Remy Leone https://github.com/remyleone/scw-s3-action
#

set -euo pipefail

: "${S3_ACCESS_KEY?S3_ACCESS_KEY environment variable must be set}"
: "${S3_SECRET_KEY?S3_SECRET_KEY environment variable must be set}"
: "${S3_ENDPOINT?S3_ENDPOINT environment variable must be set. Ex: s3.fr-par.scw.cloud}"
: "${S3_REGION?S3_REGION environment variable must be set. Ex: fr-par}"
: "${BUCKET_NAME?BUCKET_NAME environment variable must be set}"
: "${WEBSITE_CONFIG_PATH?WEBSITE_CONFIG_PATH environment variable must be set. Should be path from root project.}"
: "${BUCKET_POLICY_CONFIG_PATH?BUCKET_POLICY_CONFIG_PATH environment variable must be set. Should be path from root project.}"
: "${SOURCE_DIRECTORY?SOURCE_DIRECTORY environment variable must be set. Should be path from root project of the directory you want to sync with s3 bucket.}"
: "${SYNC_ARGS?SYNC_ARGS environment variable must be set. If you do not want to set any args please set an empty string.}"

mkdir -p ~/.aws

touch ~/.aws/config

echo "
[plugins]
endpoint = awscli_plugin_endpoint

[default]
region = ${S3_REGION}
s3 =
  endpoint_url = https://${S3_ENDPOINT}
  signature_version = s3v4
s3api =
  endpoint_url = https://${S3_ENDPOINT}
" > ~/.aws/config

touch ~/.aws/credentials

echo "[default]
aws_access_key_id = ${S3_ACCESS_KEY}
aws_secret_access_key = ${S3_SECRET_KEY}" > ~/.aws/credentials

echo "Trying to create bucket..."

set +e
aws s3 mb s3://"${BUCKET_NAME}"

if [ $? -eq 0 ]; then
    echo "Bucket created! Applying bucket website config and policy..."
    aws s3api put-bucket-website --bucket "${BUCKET_NAME}" --website-configuration file://"${WEBSITE_CONFIG_PATH}" >"${GITHUB_WORKSPACE}/aws.output"
    sed -e "s/BUCKET_NAME/'${BUCKET_NAME}'/g" "${BUCKET_POLICY_CONFIG_PATH}" > bucket-policy.json
    aws s3api put-bucket-policy --bucket "${BUCKET_NAME}" --policy file://./bucket-policy.json >"${GITHUB_WORKSPACE}/aws.output"
else
    echo "Bucket already created."
fi

echo "Starting sync..."
aws s3 sync "${SOURCE_DIRECTORY}" s3://"${BUCKET_NAME}" "${SYNC_ARGS}" >"${GITHUB_WORKSPACE}/aws.output"

# Write output to STDOUT
cat "${GITHUB_WORKSPACE}/aws.output"
