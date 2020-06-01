#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

PROD_MEDIA_BUCKET=${PROD_MEDIA_BUCKET:-mdn-media-prod}
STAGE_MEDIA_BUCKET=${STAGE_MEDIA_BUCKET:-mdn-media-stage}
DMS_URL=${DMS_URL}
OPTIONS="--exclude 'sitemaps/*' --exclude 'sitemap.xml' --cache-control max-age=31536000,public,immutable"

if [ -z "${DMS_URL}" ]; then
    echo "No DMS URL"
    exit 1
fi

aws s3 sync ${OPTIONS} "s3://${PROD_MEDIA_BUCKET}/" "s3://${STAGE_MEDIA_BUCKET}/"
RV=$?

if [ "${RV}" -eq 0 ]; then
    curl -d "s=${RV}" -s "${DMS_URL}"
fi
