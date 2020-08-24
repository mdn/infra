#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-west-2}
AWS_STS_REGIONAL_ENDPOINTS=${AWS_STS_REGIONAL_ENDPOINTS:-regional}
PROD_MEDIA_BUCKET=${PROD_MEDIA_BUCKET:-mdn-media-prod}
STAGE_MEDIA_BUCKET=${STAGE_MEDIA_BUCKET:-mdn-media-stage}
DMS_URL=${DMS_URL}
OPTIONS="--exclude 'sitemaps/*' --exclude 'sitemap.xml' --cache-control max-age=31536000,public,immutable"

if [ -z "${DMS_URL}" ]; then
    echo "No DMS URL"
    exit 1
fi

export AWS_DEFAULT_REGION
export AWS_STS_REGIONAL_ENDPOINTS

aws s3 sync ${OPTIONS} "s3://${PROD_MEDIA_BUCKET}/" "s3://${STAGE_MEDIA_BUCKET}/"
RV=$?

if [ "${RV}" -eq 0 ]; then
    curl -d "s=${RV}" -s "${DMS_URL}"
fi
