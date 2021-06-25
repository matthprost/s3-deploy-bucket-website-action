# scw-s3-bucket-website-action
Action to easily deploy any files on your S3 Bucket Website.

Here is process in order:

1. Try to create bucket
2. Set Bucket Website configuration -> **Step skipped if bucket already exist**
3. Set Website Policy -> **Step skipped if bucket already exist**
4. Upload files from source folder into bucket

## How to test locally

```shell
env -i \
  S3_ACCESS_KEY={YOUR ACCESS KEY} \
  S3_SECRET_KEY={YOUR SECRET KEY} \
  S3_ENDPOINT="s3.fr-par.scw.cloud" \ 
  S3_REGION="fr-par" \
  BUCKET_NAME="my-bucket-of-test-1234" \
  WEBSITE_CONFIG_PATH=".example.bucket-website.json" \
  BUCKET_POLICY_CONFIG_PATH="./.example.bucket-policy.json.tpl" \
  SOURCE_DIRECTORY="." \
  GITHUB_WORKSPACE="." \
  SYNC_ARGS="--delete" \
  ./entrypoint.sh
```
