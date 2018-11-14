#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

PUSH_IMAGE="rustops/crates-build-env"

# Login on Docker Hub when executing on CI
# Redefine long_timeout on CI
if [[ ! -z "${CI+x}" ]]; then
    echo "${DOCKER_PASSWORD}" | base64 --decode | docker login --username "${DOCKER_USERNAME}" --password-stdin

    disable-no-output-timeout() {
        while true; do
            sleep 60
            echo "[disable no-output timeout]"
        done
    }
else
    disable-no-output-timeout() {
        true
    }
fi

disable-no-output-timeout &

docker build -t "${PUSH_IMAGE}" .
docker push "${PUSH_IMAGE}"
