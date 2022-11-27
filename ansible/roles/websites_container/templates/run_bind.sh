#!/bin/bash -el

CONTAINER_VERSION=${CONTAINER_VERSION:-0.0.4}

docker run -it -p 53:53/udp --rm --name bind playtechnique/bind:${CONTAINER_VERSION} "$@"
