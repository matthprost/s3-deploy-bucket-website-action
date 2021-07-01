#
# ORIGINAL AUTHOR: Remy Leone https://github.com/remyleone/scw-s3-action
#

FROM python:3-alpine

ENV AWSCLI_VERSION='1.19.27'

RUN python3 -m pip --no-cache-dir install awscli==${AWSCLI_VERSION}
RUN python3 -m pip --no-cache-dir install awscli_plugin_endpoint

COPY entrypoint.sh /
RUN mkdir /s3-default-config-file
COPY .bucket-website.json /s3-default-config-file/
COPY .bucket-policy.json.tpl /s3-default-config-file/

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "help" ]
