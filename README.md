# S3 Bucket Website Deploy

Action that will create a bucket if it doesn't exist and upload your files into it.

Here is process in order:

1. Try to create bucket
2. Set Bucket Website configuration -> **Step skipped if bucket already exist**
3. Set Website Policy -> **Step skipped if bucket already exist**
4. Upload files from source folder into bucket

## How to test locally

```shell
env -i \
  INPUT_S3_ACCESS_KEY={YOUR ACCESS KEY} \
  INPUT_S3_SECRET_KEY={YOUR SECRET KEY} \
  INPUT_S3_ENDPOINT="s3.fr-par.scw.cloud" \ 
  INPUT_S3_REGION="fr-par" \
  INPUT_BUCKET_NAME="my-bucket-of-test-1234" \
  INPUT_WEBSITE_CONFIG_PATH=".bucket-website.json" \
  INPUT_BUCKET_POLICY_CONFIG_PATH=".bucket-policy.json.tpl" \
  INPUT_SOURCE_DIRECTORY="." \
  INPUT_GITHUB_WORKSPACE="." \
  INPUT_SYNC_ARGS="--delete" ./entrypoint.sh
```

### Variables

**INPUT_S3_ACCESS_KEY**: S3 access key.

**INPUT_S3_SECRET_KEY**: S3 secret key. Required.

**INPUT_S3_ENDPOINT**: S3 full endpoint. Ex: **s3.fr-par.scw.cloud** or **s3.us-west-2.amazonaws.com**.

**INPUT_S3_REGION**: Region of your bucket. Ex: **fr-par** or **nl-ams** or **us-west**

**INPUT_BUCKET_NAME**: Name of your bucket.

**INPUT_WEBSITE_CONFIG_PATH**: Root path of your bucket website configuration file. It should be a `.json`. You can find an example file [here](.bucket-website.json).

**INPUT_BUCKET_POLICY_CONFIG_PATH**: Root path of your bucket website policy file. It should be a `.json.tpl`. You can find an example file [here](.bucket-website.json).

**INPUT_SOURCE_DIRECTORY**: This is the root path of the files that will be uploaded to your S3 Bucket.

**INPUT_SYNC_ARGS**: Arguments that will be added in sync command: `aws s3 sync ./ s3://bucket-name ${SYNC_ARGS}`

## Contributions

Original Author: Rémy Léone - https://github.com/remyleone/scw-s3-action
