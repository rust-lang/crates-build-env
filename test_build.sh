#!/usr/bin/env bash
set -euo pipefail

# Build a local crates-build-env image and test a local crate in it with
# Rustwide. Rustwide runs in a Linux Docker container so the test also works on
# non-Linux hosts with Docker configured for Linux containers.

usage() {
    echo "usage: ${0##*/} <image-directory> <local-crate> [cargo-arguments...]" >&2
    echo "example: ${0##*/} linux-micro test/test-crate" >&2
}

if [ "$#" -lt 2 ]; then
    usage
    exit 2
fi

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ "$#" -eq 2 ]; then
    cargo_args=(build)
else
    cargo_args=("${@:3}")
fi
image_dir="$(cd -- "$1" && pwd)"
crate_dir="$(cd -- "$2" && pwd)"
image="crates-build-env-$(basename -- "${image_dir}"):local"

docker build --tag "${image}" "${image_dir}"
docker build --tag crates-build-env-test-runner:local "${repo_dir}/test/runner"

docker run --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume "${repo_dir}:/work" \
    --volume "${crate_dir}:/crate" \
    crates-build-env-test-runner:local \
    "${image}" /crate /work/.rustwide-test "${cargo_args[@]}"
