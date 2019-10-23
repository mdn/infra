#!/bin/bash
docker build . -t mdnwebdocs/blockaws:${GIT_COMMIT:=$(git rev-parse --short HEAD)}
docker push mdnwebdocs/blockaws:${GIT_COMMIT}
