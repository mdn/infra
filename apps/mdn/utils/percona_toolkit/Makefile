VERSION ?= $(shell git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD)
IMAGE_PREFIX ?= quay.io/metadave
IMAGE_NAME ?= percona-toolkit

all:
	docker build . -t ${IMAGE_PREFIX}/${IMAGE_NAME}:${VERSION}
	docker push ${IMAGE_PREFIX}/${IMAGE_NAME}:${VERSION}