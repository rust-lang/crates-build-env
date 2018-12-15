#!/bin/bash

# Ensure the current hostname is present in /etc/hosts
# The absence of it can be caused by setting --net=none, and it will mess
# up the sudo command executed below
if ! grep "$(cat /etc/hostname)" /etc/hosts >/dev/null 2>&1; then
    echo "127.0.0.1 $(cat /etc/hostname)" >> /etc/hosts
fi

# Create an user mapped to the host's uid with the $USER_ID environment
# variable, to make the files the container writes not be owned by root, but by
# the running host user.
if [[ ! -z "${MAP_USER_ID+x}" ]]; then
    adduser --no-create-home --disabled-login --gecos "" crates-build-env --ui "${MAP_USER_ID}" >/dev/null
    exec sudo --preserve-env --set-home -u crates-build-env -- "$@"
else
    exec "$@"
fi
