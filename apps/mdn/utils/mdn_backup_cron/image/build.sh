#!/bin/bash
GIT_COMMIT=$(git rev-parse --short=7 HEAD)
docker build -t mdnwebdocs/mdn-backup:${GIT_COMMIT} .
docker push mdnwebdocs/mdn-backup:${GIT_COMMIT}
