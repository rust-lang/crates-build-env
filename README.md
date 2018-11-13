# Build environment for Rust crates

This repository contains the source of the Docker container the Rust project
uses to build third-party crates. It is based on **Debian 9 Stretch**, and
contains all the native dependencies used by the Rust crates we know of.

## Adding new dependencies

If your crate fails to build on one of the services that uses this Docker
image, please either open an issue with the name of the packages you need or
send a pull request that adds the packages to `packages.txt`.
