#!/bin/bash

GIT_SHORT=$(git rev-parse --short HEAD)

docker build -t "limed/nginx-redirector:${GIT_SHORT}" .
docker push "limed/nginx-redirector:${GIT_SHORT}"
