#!/bin/bash

# Create an user mapped to the host's uid with the $USER_ID environment
# variable, to make the files the container writes not be owned by root, but by
# the running host user.
if [[ ! -z "${MAP_USER_ID+x}" ]]; then
    adduser --no-create-home --disabled-login --gecos "" crates-build-env --ui "${MAP_USER_ID}" >/dev/null
    exec su crates-build-env -c "$@"
else
    exec "$@"
fi
