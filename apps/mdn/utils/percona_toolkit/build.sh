#!/bin/bash

GIT_COMMIT=$(git rev-parse --short=7 HEAD)

docker build -t mdnwebdocs/percona-toolkit:${GIT_COMMIT} .
docker push mdnwebdocs/percona-toolkit:${GIT_COMMIT}
