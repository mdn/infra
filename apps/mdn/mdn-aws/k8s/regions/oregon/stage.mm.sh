#!/usr/bin/env bash
echo '--> Setting environment to STAGE(MM) in OREGON'

export KUBECONFIG=${HOME}/.kube/mdn-us-west-2.config

# Define defaults for environment variables that personalize the commands.
export TARGET_ENVIRONMENT=stage
export K8S_NAMESPACE=mdn-${TARGET_ENVIRONMENT}
export AWS_REGION=us-west-2
export K8S_CLUSTER_SHORT_NAME=oregon

# Define an alias for kubectl for convenience.
alias kc="kubectl -n ${K8S_NAMESPACE}"

export ELB_CONNECTION_DRAINING_ENABLED=True

export WEB_SERVICE_NAME=web
export WEB_SERVICE_TYPE=LoadBalancer
export WEB_SERVICE_PORT=443
export WEB_SERVICE_TARGET_PORT=8000
export WEB_SERVICE_PROTOCOL=TCP
export WEB_SERVICE_CERT_ARN=arn:aws:acm:us-west-2:178589013767:certificate/4c0418c7-6c02-4f23-89a9-f6e6709293d9

export WEB_NAME=web
export WEB_REPLICAS=1
export WEB_MAX_REPLICAS=4
export WEB_GUNICORN_WORKERS=4
export WEB_GUNICORN_TIMEOUT=90
export WEB_GUNICORN_KEEPALIVE=75
export WEB_CPU_LIMIT=2
export WEB_CPU_REQUEST=100m
export WEB_MEMORY_LIMIT=6Gi
export WEB_MEMORY_REQUEST=4Gi
export WEB_ALLOWED_HOSTS="developer.allizom.org,developer-stage.mdn.mozit.cloud,stage.mdn.mozit.cloud,files-stage.mdn.mozit.cloud,yari-demos.stage.mdn.mozit.cloud"

export CELERY_WORKERS_NAME=celery-worker
export CELERY_WORKERS_REPLICAS=1
export CELERY_WORKERS_MAX_REPLICAS=2
export CELERY_WORKERS_CPU_LIMIT=2
export CELERY_WORKERS_CPU_REQUEST=100m
export CELERY_WORKERS_MEMORY_LIMIT=4Gi
export CELERY_WORKERS_MEMORY_REQUEST=1Gi
export CELERY_WORKERS_CONCURRENCY=4
export CELERY_WORKERS_QUEUES=mdn_purgeable,mdn_search,mdn_emails,mdn_wiki,mdn_api,celery

export CELERY_BEAT_NAME=celery-beat
export CELERY_BEAT_REPLICAS=0
export CELERY_BEAT_CPU_LIMIT=1
export CELERY_BEAT_CPU_REQUEST=100m
export CELERY_BEAT_MEMORY_LIMIT=512Mi
export CELERY_BEAT_MEMORY_REQUEST=128Mi

export KUMA_IMAGE=mdnwebdocs/kuma
export KUMA_IMAGE_PULL_POLICY=IfNotPresent

export KUMA_ACCOUNT_DEFAULT_HTTP_PROTOCOL=https
export KUMA_ADMIN_NAMES="MDN devs"
export KUMA_ALLOW_ROBOTS=False
export KUMA_API_S3_BUCKET_NAME=mdn-api-stage
export KUMA_ATTACHMENT_HOST=files-stage.mdn.mozit.cloud
export KUMA_ATTACHMENT_ORIGIN=yari-demos.stage.mdn.mozit.cloud
export KUMA_ATTACHMENTS_AWS_STORAGE_BUCKET_NAME="mdn-media-stage"
export KUMA_ATTACHMENTS_AWS_S3_REGION_NAME="us-west-2"
export KUMA_ATTACHMENTS_AWS_S3_CUSTOM_DOMAIN="media.stage.mdn.mozit.cloud"
export KUMA_ATTACHMENTS_USE_S3=True
export KUMA_CELERY_TASK_ALWAYS_EAGER=False
export KUMA_CELERY_WORKER_MAX_TASKS_PER_CHILD=0
export KUMA_CSRF_COOKIE_SECURE=True
export KUMA_DEBUG=False
export KUMA_DEBUG_TOOLBAR=False
export KUMA_DOMAIN=developer.allizom.org
export KUMA_EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
export KUMA_ENABLE_CANDIDATE_LANGUAGES=True
export KUMA_ES_INDEX_PREFIX=mdnstage
export KUMA_ES_LIVE_INDEX=True
export KUMA_LEGACY_ROOT=/mdn/www
export KUMA_MAINTENANCE_MODE=True
export KUMA_MEDIA_ROOT=/mdn/www
export KUMA_MEDIA_URL=https://developer.allizom.org/media/
export KUMA_PROTOCOL="https://"
export KUMA_SECURE_HSTS_SECONDS=63072000
export KUMA_SERVE_LEGACY=True
export KUMA_SESSION_COOKIE_SECURE=True
export KUMA_STRIPE_PUBLIC_KEY=pk_test_8QPCGoZzaushrXveHRqHAZch
export KUMA_WEB_CONCURRENCY=4

export INTERACTIVE_EXAMPLES_BASE_URL=https://interactive-examples.mdn.mozilla.net
