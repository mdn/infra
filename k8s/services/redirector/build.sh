#!/bin/bash

GIT_SHORT=$(git rev-parse --short HEAD)
REPO="mdnwebdocs/redirector"

docker build -t "${REPO}:${GIT_SHORT}" .
docker push "${REPO}:${GIT_SHORT}"
