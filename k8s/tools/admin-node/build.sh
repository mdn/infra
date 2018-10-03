#/bin/bash

GIT_COMMIT=$(git rev-parse --short=7 HEAD)
docker build -t mdnwebdocs/mdn-admin:${GIT_COMMIT} .
docker push mdnwebdocs/mdn-admin:${GIT_COMMIT}
