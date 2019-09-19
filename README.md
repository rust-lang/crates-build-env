# Build environment for Rust crates

This repository contains the source of the Docker container the Rust project
uses to build third-party crates. It is based on **Ubuntu 18.04**, and contains
all the native dependencies used by the Rust crates we know of.

## Adding new dependencies

If your crate fails to build on one of the services that uses this Docker
image, please either open an issue with the name of the packages you need or
send a pull request that adds the packages to `packages.txt` or
`packages-backports.txt` (if the package is in the `stretch-backports` suite).

## Using the Docker image

The Docker image is automatically built after a commit is pushed to master, and
it's available [on Docker Hub][dockerhub] as `rustops/crates-build-env`. You
can get it with:

```
$ docker pull rustops/crates-build-env
```

The image **does not** contain a Rust toolchain in it: you need to manually
mount the toolchain you want to use inside the container.

### Mapping the user id between the container and the system

By default, the user id inside a Docker container is `0` (root). That doesn't
cause any security risk thanks to the container isolation, but it might pose
some problems when the container writes into directories mounted from the host,
since all the files in those directories will be owned by root.

This image allows to fix the issue by setting the `MAP_USER_ID` environment
variable to the user id you want to run the files. For example:

```
$ docker run --rm -e MAP_USER_ID=1000 -it rustops/crates-build-env bash
```

[dockerhub]: https://hub.docker.com/r/rustops/crates-build-env/
