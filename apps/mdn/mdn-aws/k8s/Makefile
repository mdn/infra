# Define defaults for environment variables that personalize the commands.
export TARGET_ENVIRONMENT ?= dev
export K8S_NAMESPACE ?= mdn-${TARGET_ENVIRONMENT}
export AWS_RESOURCE_STACK=MDN-${TARGET_ENVIRONMENT}
export AWS_REGION ?= us-west-2
export KUBECTL ?= kubectl

export WEB_SERVICE_NAME ?= web
export WEB_SERVICE_TYPE ?= LoadBalancer
export WEB_SERVICE_PORT ?= 443
export WEB_SERVICE_TARGET_PORT ?= 8000
export WEB_SERVICE_PROTOCOL ?= TCP

export WEB_NAME ?= web
export WEB_REPLICAS ?= 1
export WEB_MAX_REPLICAS ?= 2
export WEB_GUNICORN_WORKERS ?= 4
export WEB_GUNICORN_TIMEOUT ?= 90
export WEB_GUNICORN_KEEPALIVE ?= 75
export WEB_GUNICORN_WORKER_MAX_REQUESTS ?= 1000
export WEB_GUNICORN_WORKER_MAX_REQUESTS_JITTER ?= 200
export WEB_CPU_LIMIT ?= 2
export WEB_CPU_REQUEST ?= 100m
export WEB_MEMORY_LIMIT ?= 4Gi
export WEB_MEMORY_REQUEST ?= 256Mi
export WEB_ALLOWED_HOSTS ?= "*"
export WEB_RATELIMIT_ENABLE ?= True

export CELERY_WORKERS_NAME ?= celery-worker
export CELERY_WORKERS_REPLICAS ?= 1
export CELERY_WORKERS_MAX_REPLICAS ?= 2
export CELERY_WORKERS_CPU_LIMIT ?= 2
export CELERY_WORKERS_CPU_REQUEST ?= 100m
export CELERY_WORKERS_MEMORY_LIMIT ?= 4Gi
export CELERY_WORKERS_MEMORY_REQUEST ?= 256Mi
export CELERY_WORKERS_CONCURRENCY ?= 4
export CELERY_WORKERS_QUEUES ?= mdn_purgeable,mdn_search,mdn_emails,mdn_wiki,mdn_api,celery

export CELERY_BEAT_NAME ?= celery-beat
export CELERY_BEAT_REPLICAS ?= 1
export CELERY_BEAT_CPU_LIMIT ?= 2
export CELERY_BEAT_CPU_REQUEST ?= 100m
export CELERY_BEAT_MEMORY_LIMIT ?= 4Gi
export CELERY_BEAT_MEMORY_REQUEST ?= 256Mi

export KUMA_IMAGE ?= mdnwebdocs/kuma
export KUMA_IMAGE_PULL_POLICY ?= IfNotPresent

# Defaults for the Kuma environment.
export KUMA_ACCOUNT_DEFAULT_HTTP_PROTOCOL ?= "https"
export KUMA_ADMIN_NAMES ?= "MDN devs"
export KUMA_ATTACHMENT_HOST ?= dev.mdn.mozit.cloud
export KUMA_ATTACHMENTS_AWS_S3_CUSTOM_DOMAIN ?= ""
export KUMA_CELERY_TASK_ALWAYS_EAGER ?= False
export KUMA_CELERY_WORKER_MAX_TASKS_PER_CHILD ?= 0
export KUMA_CONN_MAX_AGE ?= 0
export KUMA_CSRF_COOKIE_SECURE ?= True
export KUMA_DEBUG ?= False
export KUMA_DEBUG_TOOLBAR ?= False
export KUMA_DOMAIN ?= dev.mdn.mozit.cloud
export KUMA_EMAIL_BACKEND ?= django.core.mail.backends.smtp.EmailBackend
export KUMA_ES_INDEX_PREFIX ?= mdn
export KUMA_ES_LIVE_INDEX ?= False
export KUMA_GOOGLE_ANALYTICS_ACCOUNT ?= 0
export KUMA_LEGACY_ROOT ?= /mdn/www
export KUMA_MAINTENANCE_MODE ?= False
export KUMA_MEDIA_ROOT ?= /mdn/www
export KUMA_MEDIA_URL ?= /media/
export KUMA_PROTOCOL ?= "https://"
export KUMA_SECURE_HSTS_SECONDS ?= 0
export KUMA_SERVE_LEGACY ?= True
export KUMA_SESSION_COOKIE_SECURE ?= True
export KUMA_STATIC_URL ?= /static/
export KUMA_WEB_CONCURRENCY ?= 4
export KUMA_FXA_TOKEN_ISSUER ?= "https://accounts.firefox.com"
export KUMA_FXA_VERIFY_URL ?= "https://oauth.accounts.firefox.com/v1/verify"
export KUMA_OIDC_RP_CLIENT_ID ?= ""
export KUMA_OIDC_CONFIGURATION_URL ?= "https://accounts.firefox.com/.well-known/openid-configuration"
export KUMA_OIDC_OP_AUTHORIZATION_ENDPOINT ?= "https://accounts.firefox.com/authorization"
export KUMA_OIDC_OP_TOKEN_ENDPOINT ?= "https://oauth.accounts.firefox.com/v1/token"
export KUMA_OIDC_OP_USER_ENDPOINT ?= "https://profile.accounts.firefox.com/v1/profile"
export KUMA_OIDC_OP_JWKS_ENDPOINT ?= "https://oauth.accounts.firefox.com/v1/jwks"

export INTERACTIVE_EXAMPLES_BASE_URL ?= https://interactive-examples.mdn.mozilla.net

export RDS_BACKUP_DIR ?= /backup
export RDS_BACKUP_DBTYPE ?= MYSQL
export RDS_BACKUP_DEBUG_MODE ?= false
export RDS_BACKUP_IMAGE_TAG ?= 88e1721
export RDS_BACKUP_IMAGE ?= mdnwebdocs/mdn-rds-backup
export RDS_BACKUP_SCHEDULE ?= "@daily"
export RDS_BACKUP_BUCKET ?= s3://mdn-rds-backup-7752d5ca6f3744a0/backups
export RDS_BACKUP_ROLE_ARN ?= "arn:aws:iam::178589013767:role/mdn-rds-backups"

export FAILED_JOBS_HISTORY_LIMIT ?= 3
export SUCCESSFUL_JOBS_HISTORY_LIMIT ?= 3

export ADMIN_NODE_NAME ?= mdn-admin

export ELB_S3_LOGGING_ENABLED ?= false
# Logging interval specified in minutes.
export ELB_S3_LOGGING_INTERVAL ?= 60
# S3 bucket name without the s3:// prefix.
export ELB_S3_LOGGING_BUCKET ?= mdn-elb-logs-c2037ed87dd96008
# ELB_S3_LOGGING_PREFIX can't end with a slash!
export ELB_S3_LOGGING_PREFIX ?= ${TARGET_ENVIRONMENT}
# Connection-idle timeout specified in seconds.
export ELB_CONNECTION_IDLE_TIMEOUT ?= 60

# ELB Connection draining
export ELB_CONNECTION_DRAINING_ENABLED ?= false
export ELB_CONNECTION_DRAINING_TIMEOUT ?= 300

### New Relic configuration
export NEW_RELIC_SECRETS_NAME ?= newrelic-secrets
export NEW_RELIC_LICENSE_KEY ?= foo
export NEW_RELIC_LICENSE_KEY_BASE64 ?= $(shell echo -n "${NEW_RELIC_LICENSE_KEY}" | base64)
export NEW_RELIC_CONFIG_FILE ?= /app/etc/newrelic.ini
export NEW_RELIC_MONITOR_MODE ?= 1
export NEW_RELIC_LOG ?= stderr
export NEW_RELIC_BROWSER_MONITOR_ENABLE ?= false
export NEW_RELIC_LABELS ?= Project:MDN;Cluster:${K8S_CLUSTER_SHORT_NAME};Namespace:${K8S_NAMESPACE}
export NEW_RELIC_LOG_LEVEL ?= info

# New Relic app names
export NEW_RELIC_MONITOR_SUFFIX ?= ${TARGET_ENVIRONMENT}-${K8S_CLUSTER_SHORT_NAME}
export NEW_RELIC_ROLLUP_NAME ?= kuma-${NEW_RELIC_MONITOR_SUFFIX}
export NEW_RELIC_WEB_NAME ?= "kuma-web-${NEW_RELIC_MONITOR_SUFFIX};${NEW_RELIC_ROLLUP_NAME}"
export NEW_RELIC_CELERY_NAME ?= "kuma-backend-${NEW_RELIC_MONITOR_SUFFIX};${NEW_RELIC_ROLLUP_NAME}"

export PERCONA_TOOLKIT_NS ?= percona-toolkit
export PERCONA_TOOLKIT_IMAGE ?= mdnwebdocs/percona-toolkit:226571b

export MEDIA_SYNC_NS ?= mdn-cron
export MEDIA_SYNC_IMAGE ?= mdnwebdocs/media-sync
export MEDIA_SYNC_IMAGE_TAG ?= cafc23c
export MEDIA_SYNC_DEBUG_MODE ?= false
export MEDIA_SYNC_ROLE_ARN ?= "arn:aws:iam::178589013767:role/media-sync-role"

# Redirector
export REDIRECTOR_NAME ?= "redirector"
export REDIRECTOR_NAMESPACE ?= "redirector"
export REDIRECTOR_REPLICAS ?= 1
export REDIRECTOR_MAX_REPLICAS ?= 4
export REDIRECTOR_IMAGE_NAME ?= mdnwebdocs/redirector
export REDIRECTOR_IMAGE_TAG ?= 3c86c15
export REDIRECTOR_SERVICE_PORT ?= 80
export REDIRECTOR_CONTAINER_PORT ?= 80
# This list must be without quotes
export REDIRECTOR_HOSTS ?= mozilla.dev,www.mozilla.dev,developer.mozilla.com,beta.developer.mozilla.org,wiki.developer.mozilla.org

###############################
### core tasks

k8s-ns: check-service-env
	${KUBECTL} create ns ${K8S_NAMESPACE} | true

k8s-delete-ns: check-service-env
	${KUBECTL} delete --ignore-not-found ns ${K8S_NAMESPACE}

k8s-services: k8s-web-svc

test-k8s-services: test-k8s-web-svc

k8s-delete-services: k8s-delete-web-svc

k8s-deployments: k8s-kuma-deployments

test-k8s-deployments: test-k8s-kuma-deployments

k8s-delete-deployments: k8s-delete-kuma-deployments

k8s-kuma-deployments: k8s-web k8s-celery k8s-hpa-web k8s-hpa-celery-workers

test-k8s-kuma-deployments: test-k8s-web test-k8s-celery test-k8s-hpa-web test-k8s-hpa-celery-workers

k8s-delete-kuma-deployments: k8s-delete-web k8s-delete-celery k8s-delete-hpa-web k8s-delete-hpa-celery-workers

k8s-rollout-status: k8s-kuma-rollout-status

k8s-kuma-rollout-status:
	${KUBECTL} -n ${K8S_NAMESPACE} rollout status deploy ${WEB_NAME}
	${KUBECTL} -n ${K8S_NAMESPACE} rollout status deploy ${CELERY_WORKERS_NAME}
	${KUBECTL} -n ${K8S_NAMESPACE} rollout status deploy ${CELERY_BEAT_NAME}

k8s-rollback: k8s-kuma-rollback

k8s-kuma-rollback:
	${KUBECTL} -n ${K8S_NAMESPACE} rollout undo deploy ${WEB_NAME}
	${KUBECTL} -n ${K8S_NAMESPACE} rollout undo deploy ${CELERY_WORKERS_NAME}
	${KUBECTL} -n ${K8S_NAMESPACE} rollout undo deploy ${CELERY_BEAT_NAME}

k8s-history: k8s-kuma-history

k8s-kuma-history:
	${KUBECTL} -n ${K8S_NAMESPACE} rollout history deploy ${WEB_NAME}
	${KUBECTL} -n ${K8S_NAMESPACE} rollout history deploy ${CELERY_WORKERS_NAME}
	${KUBECTL} -n ${K8S_NAMESPACE} rollout history deploy ${CELERY_BEAT_NAME}

k8s-db-migration-job: k8s-delete-db-migration-job
	env KUMA_NAME=mdn-db-migration \
		KUMA_CPU_LIMIT=${WEB_CPU_LIMIT} \
		KUMA_MEMORY_LIMIT=${WEB_MEMORY_LIMIT} \
		KUMA_CPU_REQUEST=${WEB_CPU_REQUEST} \
		KUMA_MEMORY_REQUEST=${WEB_MEMORY_REQUEST} \
		KUMA_ALLOWED_HOSTS=${WEB_ALLOWED_HOSTS} \
		KUMA_RATELIMIT_ENABLE=False \
		NEW_RELIC_APP_NAME=${NEW_RELIC_WEB_NAME} \
		j2 mdn-db-migration-job.yaml.j2 | ${KUBECTL} apply -n ${K8S_NAMESPACE} -f -
	env JOB_NAME=mdn-db-migration ./wait_for_job.sh

k8s-delete-db-migration-job:
	${KUBECTL} delete -n ${K8S_NAMESPACE} --ignore-not-found job mdn-db-migration

k8s-kuma-record-deployment-job: k8s-kuma-delete-record-deployment-job
	@ echo FROM_REVISION_HASH=${FROM_REVISION_HASH}
	@ echo TO_REVISION_HASH=${TO_REVISION_HASH}
	env APP_NAME=kuma \
		j2 mdn-record-deployment-job.yaml.j2 | ${KUBECTL} apply -n ${K8S_NAMESPACE} -f -
	env JOB_NAME=mdn-kuma-record-deployment ./wait_for_job.sh

k8s-kuma-delete-record-deployment-job:
	${KUBECTL} delete -n ${K8S_NAMESPACE} --ignore-not-found job mdn-kuma-record-deployment

### end core tasks
###############################

k8s-web-svc: check-service-env
	env SERVICE_NAME=${WEB_SERVICE_NAME} \
		SERVICE_TYPE=${WEB_SERVICE_TYPE} \
		SERVICE_PORT=${WEB_SERVICE_PORT} \
		SERVICE_TARGET_PORT=${WEB_SERVICE_TARGET_PORT} \
		SERVICE_PROTOCOL=${WEB_SERVICE_PROTOCOL} \
		SERVICE_CERT_ARN=${WEB_SERVICE_CERT_ARN} \
		TARGET_ENVIRONMENT=${TARGET_ENVIRONMENT} \
		ELB_S3_LOGGING_ENABLED=false \
		j2 cert.svc.yaml.j2 | ${KUBECTL} apply -n ${K8S_NAMESPACE} -f -

test-k8s-web-svc:
	env SERVICE_NAME=${WEB_SERVICE_NAME} \
		SERVICE_TYPE=${WEB_SERVICE_TYPE} \
		SERVICE_PORT=${WEB_SERVICE_PORT} \
		SERVICE_TARGET_PORT=${WEB_SERVICE_TARGET_PORT} \
		SERVICE_PROTOCOL=${WEB_SERVICE_PROTOCOL} \
		SERVICE_CERT_ARN=${WEB_SERVICE_CERT_ARN} \
		TARGET_ENVIRONMENT=${TARGET_ENVIRONMENT} \
		ELB_S3_LOGGING_ENABLED=false \
	j2 cert.svc.yaml.j2 | kubeval --strict --ignore-missing-schemas

k8s-delete-web-svc: check-service-env
	${KUBECTL} delete -n ${K8S_NAMESPACE} --ignore-not-found \
		svc ${WEB_SERVICE_NAME}

###############################
### administrative tasks
# not referenced from parent targets

k8s-newrelic-secrets: check-service-env
	j2 mdn-newrelic-secrets.yaml.j2 | ${KUBECTL} apply -n ${K8S_NAMESPACE} -f -

k8s-delete-newrelic-secrets: check-service-env
	${KUBECTL} delete -n ${K8S_NAMESPACE} --ignore-not-found secret ${NEW_RELIC_SECRETS_NAME}

k8s-admin-node: check-service-env
	j2 mdn-admin-node.yaml.j2 | ${KUBECTL} apply -n ${K8S_NAMESPACE} -f -

test-k8s-admin-node:
	j2 mdn-admin-node.yaml.j2 | kubeval --strict --ignore-missing-schemas

k8s-delete-admin-node: check-service-env
	${KUBECTL} delete -n ${K8S_NAMESPACE} --ignore-not-found deployment ${ADMIN_NODE_NAME}

k8s-rds-backup-cron: check-service-env
	j2 mdn-rds-backup-cron.yaml.j2 | ${KUBECTL} apply -n ${K8S_NAMESPACE} -f -

k8s-delete-rds-backup-cron: check-service-env
	${KUBECTL} delete -n ${K8S_NAMESPACE} --ignore-not-found cronjob mdn-rds-backup

#check-service-env
k8s-percona-toolkit-ptkill: check-service-env
	j2 percona-toolkit-ptkill.yaml.j2 | ${KUBECTL} apply -n ${PERCONA_TOOLKIT_NS} -f -

k8s-delete-percona-toolkit-ptkill: check-service-env
	${KUBECTL} delete -n ${PERCONA_TOOLKIT_NS} --ignore-not-found deployment percona-toolkit-ptkill

k8s-media-sync-cron: check-service-env
	j2 mdn-media-sync-cron.yaml.j2 | ${KUBECTL} apply -n ${MEDIA_SYNC_NS} -f -

k8s-delete-media-sync-cron:
	${KUBECTL} delete -n ${MEDIA_SYNC_NS} --ignore-not-found cronjob  mdn-media-sync

test-k8s-media-sync-cron: check-service-env
	j2 mdn-media-sync-cron.yaml.j2 | kubeval --strict --ignore-missing-schemas

k8s-redirector: k8s-redirector-ingress k8s-redirector-service k8s-redirector-hpa k8s-redirector-deployment

k8s-redirector-ns:
	kubectl create ns ${REDIRECTOR_NAMESPACE} | true

k8s-redirector-ingress:
	j2 redirector.ingress.yaml.j2 | kubectl -n ${REDIRECTOR_NAMESPACE} apply -f -

test-k8s-redirector-ingress:
	j2 redirector.ingress.yaml.j2 | kubeval --strict --ignore-missing-schemas

k8s-redirector-service:
	j2 redirector.svc.yaml.j2 | kubectl -n ${REDIRECTOR_NAMESPACE} apply -f -

test-k8s-redirector-service:
	j2 redirector.svc.yaml.j2 | kubeval --strict --ignore-missing-schemas

k8s-redirector-hpa:
	env HPA_NAME=${REDIRECTOR_NAME} \
		HPA_REPLICAS=${REDIRECTOR_REPLICAS} \
		HPA_MAX_REPLICAS=${REDIRECTOR_MAX_REPLICAS} \
		HPA_ENVIROMENT="core" \
	j2 hpa.yaml.j2 | kubectl -n ${REDIRECTOR_NAMESPACE} apply -f -

test-k8s-redirector-hpa:
	env HPA_NAME=${REDIRECTOR_NAME} \
		HPA_REPLICAS=${REDIRECTOR_REPLICAS} \
		HPA_MAX_REPLICAS=${REDIRECTOR_MAX_REPLICAS} \
		HPA_ENVIROMENT="core" \
	j2 hpa.yaml.j2 | kubeval --strict --ignore-missing-schemas

k8s-delete-redirector-hpa:
	kubectl -n ${REDIRECTOR_NAMESPACE} delete --ignore-not-found hpa ${REDIRECTOR_NAME}

k8s-redirector-deployment:
	j2 redirector.deployment.yaml.j2 | kubectl -n ${REDIRECTOR_NAMESPACE} apply -f -

test-k8s-redirector-deployment:
	j2 redirector.deployment.yaml.j2 | kubeval --strict --ignore-missing-schemas

k8s-delete-redirector-ingress:
	kubectl -n ${REDIRECTOR_NAMESPACE} delete --ignore-not-found ing ${REDIRECTOR_NAME}

k8s-delete-redirector-service:
	kubectl -n ${REDIRECTOR_NAMESPACE} delete --ignore-not-found svc ${REDIRECTOR_NAME}

k8s-delete-redirector-deployment:
	kubectl -n ${REDIRECTOR_NAMESPACE} delete --ignore-not-found deploy ${REDIRECTOR_NAME}

### end administrative tasks
###############################

k8s-web:
	env KUMA_NAME=${WEB_NAME} \
		KUMA_REPLICAS=${WEB_REPLICAS} \
		KUMA_APP_LABEL=${WEB_SERVICE_NAME} \
		KUMA_CONTAINER_PORT=${WEB_SERVICE_TARGET_PORT} \
		KUMA_GUNICORN_WORKERS=${WEB_GUNICORN_WORKERS} \
		KUMA_GUNICORN_TIMEOUT=${WEB_GUNICORN_TIMEOUT} \
		KUMA_GUNICORN_KEEPALIVE=${WEB_GUNICORN_KEEPALIVE} \
		KUMA_GUNICORN_WORKER_MAX_REQUESTS=${WEB_GUNICORN_WORKER_MAX_REQUESTS} \
		KUMA_GUNICORN_WORKER_MAX_REQUESTS_JITTER=${WEB_GUNICORN_WORKER_MAX_REQUESTS_JITTER} \
		KUMA_CPU_LIMIT=${WEB_CPU_LIMIT} \
		KUMA_MEMORY_LIMIT=${WEB_MEMORY_LIMIT} \
		KUMA_CPU_REQUEST=${WEB_CPU_REQUEST} \
		KUMA_MEMORY_REQUEST=${WEB_MEMORY_REQUEST} \
		KUMA_ALLOWED_HOSTS=${WEB_ALLOWED_HOSTS} \
		KUMA_RATELIMIT_ENABLE=${WEB_RATELIMIT_ENABLE} \
		NEW_RELIC_APP_NAME=${NEW_RELIC_WEB_NAME} \
		j2 kuma.deploy.yaml.j2 | ${KUBECTL} apply -n ${K8S_NAMESPACE} -f -

test-k8s-web:
	env KUMA_NAME=${WEB_NAME} \
		KUMA_REPLICAS=${WEB_REPLICAS} \
		KUMA_APP_LABEL=${WEB_SERVICE_NAME} \
		KUMA_CONTAINER_PORT=${WEB_SERVICE_TARGET_PORT} \
		KUMA_GUNICORN_WORKERS=${WEB_GUNICORN_WORKERS} \
		KUMA_GUNICORN_TIMEOUT=${WEB_GUNICORN_TIMEOUT} \
		KUMA_GUNICORN_KEEPALIVE=${WEB_GUNICORN_KEEPALIVE} \
		KUMA_GUNICORN_WORKER_MAX_REQUESTS=${WEB_GUNICORN_WORKER_MAX_REQUESTS} \
		KUMA_GUNICORN_WORKER_MAX_REQUESTS_JITTER=${WEB_GUNICORN_WORKER_MAX_REQUESTS_JITTER} \
		KUMA_CPU_LIMIT=${WEB_CPU_LIMIT} \
		KUMA_MEMORY_LIMIT=${WEB_MEMORY_LIMIT} \
		KUMA_CPU_REQUEST=${WEB_CPU_REQUEST} \
		KUMA_MEMORY_REQUEST=${WEB_MEMORY_REQUEST} \
		KUMA_ALLOWED_HOSTS=${WEB_ALLOWED_HOSTS} \
		KUMA_RATELIMIT_ENABLE=${WEB_RATELIMIT_ENABLE} \
		NEW_RELIC_APP_NAME=${NEW_RELIC_WEB_NAME} \
	j2 kuma.deploy.yaml.j2 | kubeval --strict --ignore-missing-schemas

k8s-delete-web:
	${KUBECTL} delete -n ${K8S_NAMESPACE} --ignore-not-found deploy ${WEB_NAME}

k8s-hpa-web:
	j2 hpa.web.yaml.j2 | ${KUBECTL} apply -n ${K8S_NAMESPACE} -f -

test-k8s-hpa-web:
	j2 hpa.web.yaml.j2 | kubeval --strict --ignore-missing-schemas

k8s-delete-hpa-web:
	${KUBECTL} delete -n ${K8S_NAMESPACE} --ignore-not-found hpa ${WEB_NAME}

k8s-celery: k8s-celery-workers k8s-celery-beat

test-k8s-celery: test-k8s-celery-workers test-k8s-celery-beat

k8s-delete-celery: k8s-delete-celery-workers k8s-delete-celery-beat

k8s-celery-workers:
	env KUMA_NAME=${CELERY_WORKERS_NAME} \
		KUMA_APP_LABEL=${CELERY_WORKERS_NAME} \
		KUMA_REPLICAS=${CELERY_WORKERS_REPLICAS} \
		KUMA_CPU_LIMIT=${CELERY_WORKERS_CPU_LIMIT} \
		KUMA_MEMORY_LIMIT=${CELERY_WORKERS_MEMORY_LIMIT} \
		KUMA_CPU_REQUEST=${CELERY_WORKERS_CPU_REQUEST} \
		KUMA_MEMORY_REQUEST=${CELERY_WORKERS_MEMORY_REQUEST} \
		KUMA_ALLOWED_HOSTS="" \
		KUMA_RATELIMIT_ENABLE=False \
		NEW_RELIC_APP_NAME=${NEW_RELIC_CELERY_NAME} \
		j2 celery.workers.deploy.yaml.j2 | ${KUBECTL} apply -n ${K8S_NAMESPACE} -f -

test-k8s-celery-workers:
	env KUMA_NAME=${CELERY_WORKERS_NAME} \
		KUMA_APP_LABEL=${CELERY_WORKERS_NAME} \
		KUMA_REPLICAS=${CELERY_WORKERS_REPLICAS} \
		KUMA_CPU_LIMIT=${CELERY_WORKERS_CPU_LIMIT} \
		KUMA_MEMORY_LIMIT=${CELERY_WORKERS_MEMORY_LIMIT} \
		KUMA_CPU_REQUEST=${CELERY_WORKERS_CPU_REQUEST} \
		KUMA_MEMORY_REQUEST=${CELERY_WORKERS_MEMORY_REQUEST} \
		KUMA_ALLOWED_HOSTS="" \
		KUMA_RATELIMIT_ENABLE=False \
		NEW_RELIC_APP_NAME=${NEW_RELIC_CELERY_NAME} \
	j2 celery.workers.deploy.yaml.j2 | kubeval --strict --ignore-missing-schemas

k8s-delete-celery-workers:
	${KUBECTL} delete -n ${K8S_NAMESPACE} --ignore-not-found \
		deploy ${CELERY_WORKERS_NAME}

k8s-hpa-celery-workers:
	j2 hpa.celery.yaml.j2 | ${KUBECTL} apply -n ${K8S_NAMESPACE} -f -

test-k8s-hpa-celery-workers:
	j2 hpa.celery.yaml.j2 | kubeval --strict --ignore-missing-schemas

k8s-delete-hpa-celery-workers:
	${KUBECTL} delete -n ${K8S_NAMESPACE} --ignore-not-found hpa ${CELERY_WORKERS_NAME}

k8s-celery-beat:
	env KUMA_NAME=${CELERY_BEAT_NAME} \
		KUMA_APP_LABEL=${CELERY_BEAT_NAME} \
		KUMA_REPLICAS=${CELERY_BEAT_REPLICAS} \
		KUMA_CPU_LIMIT=${CELERY_BEAT_CPU_LIMIT} \
		KUMA_MEMORY_LIMIT=${CELERY_BEAT_MEMORY_LIMIT} \
		KUMA_CPU_REQUEST=${CELERY_BEAT_CPU_REQUEST} \
		KUMA_MEMORY_REQUEST=${CELERY_BEAT_MEMORY_REQUEST} \
		KUMA_ALLOWED_HOSTS="" \
		KUMA_RATELIMIT_ENABLE=False \
		NEW_RELIC_APP_NAME="" \
		j2 celery.beat.deploy.yaml.j2 | ${KUBECTL} apply -n ${K8S_NAMESPACE} -f -

test-k8s-celery-beat:
	env KUMA_NAME=${CELERY_BEAT_NAME} \
		KUMA_APP_LABEL=${CELERY_BEAT_NAME} \
		KUMA_REPLICAS=${CELERY_BEAT_REPLICAS} \
		KUMA_CPU_LIMIT=${CELERY_BEAT_CPU_LIMIT} \
		KUMA_MEMORY_LIMIT=${CELERY_BEAT_MEMORY_LIMIT} \
		KUMA_CPU_REQUEST=${CELERY_BEAT_CPU_REQUEST} \
		KUMA_MEMORY_REQUEST=${CELERY_BEAT_MEMORY_REQUEST} \
		KUMA_ALLOWED_HOSTS="" \
		KUMA_RATELIMIT_ENABLE=False \
		NEW_RELIC_APP_NAME="" \
	j2 celery.beat.deploy.yaml.j2 | kubeval --strict --ignore-missing-schemas

k8s-delete-celery-beat:
	${KUBECTL} delete -n ${K8S_NAMESPACE} --ignore-not-found \
		deploy ${CELERY_BEAT_NAME}

check-service-env:
	./check_infra_lock.sh

k8s-get-kuma-revision-hash:
	@ ${KUBECTL} -n ${K8S_NAMESPACE} exec $(shell ${KUBECTL} -n ${K8S_NAMESPACE} get pods --selector app=${WEB_SERVICE_NAME} -o jsonpath='{.items[0].metadata.name}') -- printenv REVISION_HASH

# These tasks don't have file targets
.PHONY: k8s-services k8s-delete-services k8s-ns k8s-delete-ns \
		k8s-web-svc k8s-delete-web-svc \
		k8s-deployments k8s-delete-deployments \
		k8s-web k8s-delete-web \
	    k8s-celery k8s-delete-celery \
		k8s-celery-workers k8s-delete-celery-workers \
		k8s-celery-beat k8s-delete-celery-beat \
		k8s-kuma-deployments k8s-delete-kuma-deployments \
		k8s-delete-hpa-web k8s-delete-hpa-celery-workers \
		k8s-rollout-status k8s-kuma-rollout-status \
		k8s-kuma-record-deployment-job k8s-kuma-delete-record-deployment-job \
		k8s-get-kuma-revision-hash \
		k8s-rds-backup-cron k8s-delete-rds-backup-cron \
		k8s-redirector \
		check-service-env
