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
    if ! id "${MAP_USER_ID}" >/dev/null 2>&1; then
        adduser --no-create-home --disabled-login --gecos "" crates-build-env --ui "${MAP_USER_ID}" >/dev/null
    fi

    if [[ ! -z "${MAP_GROUP_ID+x}" ]]; then
        if ! getent group "${MAP_GROUP_ID}" >/dev/null 2>&1; then
            addgroup --gid "${MAP_GROUP_ID}" crates-build-env-mapped-group >/dev/null
        fi

        exec sudo --preserve-env --set-home -g "#${MAP_GROUP_ID}" -u "#${MAP_USER_ID}" -- "$@"
    else
        exec sudo --preserve-env --set-home -u "#${MAP_USER_ID}" -- "$@"
    fi
else
    exec "$@"
fi
