#!/usr/bin/env bash
echo '--> Setting environment to PROD in OREGON'

export KUBECONFIG=${HOME}/.kube/oregon.config

# Define defaults for environment variables that personalize the commands.
export TARGET_ENVIRONMENT=prod
export K8S_NAMESPACE=mdn-${TARGET_ENVIRONMENT}
export AWS_REGION=us-west-2
export K8S_CLUSTER_SHORT_NAME=oregon

# Define an alias for kubectl for convenience.
alias kc="kubectl -n ${K8S_NAMESPACE}"

# Note PVs are available within ALL namespaces, so delimit them with
# the name of the target environment.
export SHARED_PV_NAME=mdn-shared-${TARGET_ENVIRONMENT}
export SHARED_PV_SIZE=1000Gi
export SHARED_PV_RECLAIM_POLICY=Retain
export SHARED_PV_MOUNT_PATH=/
export SHARED_PV_ARN=fs-543814fd.efs.us-west-2.amazonaws.com
export SHARED_PV_STORAGE_CLASS_NAME=efs

export SHARED_PVC_NAME=mdn-shared
export SHARED_PVC_SIZE=200Gi

export WEB_SERVICE_NAME=web
export WEB_SERVICE_TYPE=LoadBalancer
export WEB_SERVICE_PORT=443
export WEB_SERVICE_TARGET_PORT=8000
export WEB_SERVICE_PROTOCOL=TCP
export WEB_SERVICE_CERT_ARN=arn:aws:acm:us-west-2:178589013767:certificate/6cd2746f-26e7-491f-95ba-4972b1aa5879

export API_SERVICE_NAME=api
export API_SERVICE_TYPE=ClusterIP
export API_SERVICE_PORT=80
export API_SERVICE_TARGET_PORT=8000
export API_SERVICE_PROTOCOL=TCP

export KUMASCRIPT_SERVICE_NAME=kumascript
export KUMASCRIPT_SERVICE_TYPE=ClusterIP
export KUMASCRIPT_SERVICE_PORT=9080
export KUMASCRIPT_SERVICE_TARGET_PORT=9080
export KUMASCRIPT_SERVICE_PROTOCOL=TCP

export SSR_SERVICE_NAME=ssr
export SSR_SERVICE_TYPE=ClusterIP
export SSR_SERVICE_PORT=80
export SSR_SERVICE_TARGET_PORT=8000
export SSR_SERVICE_PROTOCOL=TCP

export WEB_NAME=web
export WEB_REPLICAS=20
export WEB_GUNICORN_WORKERS=8
export WEB_GUNICORN_TIMEOUT=118
export WEB_CPU_LIMIT=4
export WEB_CPU_REQUEST=500m
export WEB_MEMORY_LIMIT=6Gi
export WEB_MEMORY_REQUEST=4Gi
export WEB_ALLOWED_HOSTS="developer.mozilla.org,beta.developer.mozilla.org,wiki.developer.mozilla.org,mdn.mozillademos.org,demos.mdn.mozit.cloud,demos-origin.mdn.mozit.cloud,developer-prod.mdn.mozit.cloud,prod.mdn.mozit.cloud"

export API_NAME=api
export API_REPLICAS=2
export API_GUNICORN_WORKERS=4
export API_GUNICORN_TIMEOUT=120
export API_CPU_LIMIT=4
export API_CPU_REQUEST=500m
export API_MEMORY_LIMIT=4Gi
export API_MEMORY_REQUEST=2Gi

export SSR_NAME=ssr
export SSR_REPLICAS=10
export SSR_CPU_LIMIT=1
export SSR_CPU_REQUEST=500m
export SSR_MEMORY_LIMIT=2Gi
export SSR_MEMORY_REQUEST=1Gi
export SSR_CONTAINER_PORT=${SSR_SERVICE_TARGET_PORT}

export CELERY_WORKERS_NAME=celery-worker
export CELERY_WORKERS_REPLICAS=10
export CELERY_WORKERS_CPU_LIMIT=4
export CELERY_WORKERS_CPU_REQUEST=500m
export CELERY_WORKERS_MEMORY_LIMIT=4Gi
export CELERY_WORKERS_MEMORY_REQUEST=2Gi
export CELERY_WORKERS_CONCURRENCY=4
export CELERY_WORKERS_QUEUES=mdn_purgeable,mdn_search,mdn_emails,mdn_wiki,mdn_api,celery

export CELERY_BEAT_NAME=celery-beat
export CELERY_BEAT_REPLICAS=1
export CELERY_BEAT_CPU_LIMIT=1
export CELERY_BEAT_CPU_REQUEST=250m
export CELERY_BEAT_MEMORY_LIMIT=1Gi
export CELERY_BEAT_MEMORY_REQUEST=256Mi

export KUMASCRIPT_NAME=kumascript
export KUMASCRIPT_REPLICAS=4
export KUMASCRIPT_CONTAINER_PORT=${KUMASCRIPT_SERVICE_TARGET_PORT}
export KUMASCRIPT_IMAGE=mdnwebdocs/kumascript
export KUMASCRIPT_IMAGE_PULL_POLICY=IfNotPresent
export KUMASCRIPT_CPU_LIMIT=4
export KUMASCRIPT_CPU_REQUEST=500m
export KUMASCRIPT_MEMORY_LIMIT=2Gi
export KUMASCRIPT_MEMORY_REQUEST=1Gi

export KUMA_IMAGE=mdnwebdocs/kuma
export KUMA_IMAGE_PULL_POLICY=IfNotPresent
# "KUMA_MOUNT_PATH" sets the mount path for the claim of the shared volume.
export KUMA_MOUNT_PATH=/mdn

export KUMA_ACCOUNT_DEFAULT_HTTP_PROTOCOL=https
export KUMA_ADMIN_NAMES="MDN devs"
export KUMA_ALLOW_ROBOTS=True
export KUMA_API_S3_BUCKET_NAME=mdn-api-prod
export KUMA_ATTACHMENT_HOST=mdn.mozillademos.org
export KUMA_ATTACHMENT_ORIGIN=demos-origin.mdn.mozit.cloud
export KUMA_ATTACHMENTS_AWS_STORAGE_BUCKET_NAME="mdn-media-prod"
export KUMA_ATTACHMENTS_AWS_S3_REGION_NAME="us-west-2"
export KUMA_ATTACHMENTS_AWS_S3_CUSTOM_DOMAIN="media.prod.mdn.mozit.cloud"
export KUMA_ATTACHMENTS_USE_S3=True
export KUMA_CELERY_TASK_ALWAYS_EAGER=False
export KUMA_CELERY_WORKER_MAX_TASKS_PER_CHILD=0
export KUMA_CSP_ENABLE_MIDDLEWARE=False
export KUMA_CSP_REPORT_ENABLE=False
export KUMA_CSP_REPORT_ONLY=True
export KUMA_CSRF_COOKIE_SECURE=True
export KUMA_DEBUG=False
export KUMA_DEBUG_TOOLBAR=False
export KUMA_DOMAIN=developer.mozilla.org
export KUMA_EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
export KUMA_ENABLE_CANDIDATE_LANGUAGES=False
export KUMA_ENABLE_CONTRIBUTIONS=True
export KUMA_ENABLE_CONTRIBUTIONS_CONFIRMATION_EMAIL=True
export KUMA_ES_INDEX_PREFIX=mdnprod
export KUMA_ES_LIVE_INDEX=True
export KUMA_FOUNDATION_CALLOUT=False
export KUMA_GOOGLE_ANALYTICS_ACCOUNT=UA-36116321-5
export KUMA_LEGACY_ROOT=/mdn/www
export KUMA_MAINTENANCE_MODE=False
export KUMA_MEDIA_ROOT=/mdn/www
export KUMA_MEDIA_URL=https://developer.mozilla.org/media/
export KUMA_MULTI_AUTH_ENABLED=True
export KUMA_PROTOCOL="https://"
export KUMA_SECURE_HSTS_SECONDS=63072000
export KUMA_SERVE_LEGACY=True
export KUMA_SESSION_COOKIE_SECURE=True
export KUMA_STRIPE_PLAN_ID=plan_monthly_500_usd
export KUMA_STRIPE_PUBLIC_KEY=pk_live_GZl4tCi8J5mWhKbJeRey4DSy
export KUMA_WEB_CONCURRENCY=4

export INTERACTIVE_EXAMPLES_BASE_URL=https://interactive-examples.mdn.mozilla.net

export SYNC_BUCKET=s3://mdn-efs-backup-c2037ed87dd96008
export BACKUP_BUCKET=s3://mdn-efs-backup-c2037ed87dd96008
