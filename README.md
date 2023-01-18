# Build environment for third-party Rust crates

This repository contains the source code and the tooling to produce the Docker
containers used by [Crater] and [docs.rs] to build third-party crates. The
contents of this repository are released under the MIT license.

 The images **do not** contain a Rust toolchain in them: you'll need to manually
 mount the toolchain(s) you want to use inside the container.

## Adding new dependencies

If your crate fails to build on [Crater] or [docs.rs], you can:

* [Open an issue][new-issue-linux] with the names of the packages you need
* Send a PR adding the package names to the `linux/packages.txt` file

Note that the package needs to be available in the **Ubuntu 22.04** archives.

## Available containers

### `linux`

This container is based on **Ubuntu 22.04** and includes all the native
dependencies used by Rust crates we know of. It's used as the build environment
for the [Crater] and [docs.rs] projects.

You can pull this container by running:

```
docker pull ghcr.io/rust-lang/crates-build-env/linux:latest
```

### `linux-micro`

This container is based on **Ubuntu 22.04** and includes the minimum set of
dependencies needed to compile simple Rust programs. It's used by the test
suites of [Crater] and [docs.rs] and during local development.

You can pull this container by running:

```
docker pull ghcr.io/rust-lang/crates-build-env/linux-micro:latest
```

### `windows`

This *work in progress* container is based on **Windows 2019**. It's currently
unused and unmaintained, and no automated builds for it are available.

[Crater]: https://github.com/rust-lang/crater
[docs.rs]: https://github.com/rust-lang/docs.rs
[new-issue-linux]: https://github.com/rust-lang/crates-build-env/issues/new?template=missing-linux-packages.md
