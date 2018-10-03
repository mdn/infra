GIT_COMMIT ?= $(shell git rev-parse --short=7 HEAD)

all:
	docker build . -t mdnwebdocs/mdn-rds-backup:${GIT_COMMIT}
	docker push mdnwebdocs/mdn-rds-backup:${GIT_COMMIT}
