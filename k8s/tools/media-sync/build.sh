#!/bin/bash

#!/bin/bash
docker build . -t mdnwebdocs/media-sync:${GIT_COMMIT:=$(git rev-parse --short HEAD)}
docker push mdnwebdocs/media-sync:${GIT_COMMIT}
