# Build environment for third-party Rust crates

This repository contains the source code and the tooling to produce the Docker
containers used by [Crater] and [docs.rs] to build third-party crates. The
contents of this repository are released under the MIT license.

The images **do not** contain a Rust toolchain in them: you'll need to manually
mount the toolchain(s) you want to use inside the container.

## Available containers

### `linux`

This container is based on **Ubuntu 26.04** and includes all the native
dependencies used by Rust crates we know of. It's used as the build environment
for the [Crater] and [docs.rs] projects.

You can pull this container by running:

```console
docker pull ghcr.io/rust-lang/crates-build-env/linux:latest
```

### `linux-micro`

This container is based on **Ubuntu 26.04** and includes the minimum set of
dependencies needed to compile simple Rust programs. It's used by the test
suites of [Crater] and [docs.rs] and during local development.

You can pull this container by running:

```console
docker pull ghcr.io/rust-lang/crates-build-env/linux-micro:latest
```

### `windows`

This _work in progress_ container is based on **Windows 2019**. It's currently
unused and unmaintained, and no automated builds for it are available.

## Linux distro update policy

The `linux` and `linux-micro` containers track Ubuntu LTS releases. When the
base distro is updated, we move to the current Ubuntu LTS rather than following
interim Ubuntu releases.

Anyone can send the PR for a distro update. If you want to help with the
transition to the next Ubuntu LTS, feel free to open a PR with the required
changes.

## Adding new dependencies

If a crate needs a native library that is missing from the image, add its Ubuntu
package name to the appropriate alphabetically sorted package list:

- `linux/packages.txt` for the full image
- `linux-micro/packages.txt` for the minimal image

The package must be available in the **Ubuntu 26.04** repositories. Use the
package search at [packages.ubuntu.com](https://packages.ubuntu.com/) or
`apt search` to find the name. For iterative package work, temporarily add
packages to the Dockerfile after the existing install step to reuse the cached
package layer, then move them into `packages.txt` once confirmed. A cold Docker
image build can take 10–20 minutes; subsequent builds reuse Docker layers. Once
the crate builds, run `./lint.sh` before committing to verify package ordering.

### Testing the Linux image locally

The test requires Docker with Linux containers and Bash (including Git Bash or
WSL on Windows). The image and local crate paths are resolved from the directory
where `test_build.sh` is invoked and may be relative or absolute.

After adding a system dependency, run `./test_build.sh <image-directory>
<local-crate> [cargo-arguments...]` to rebuild the image and check whether the
package fixes the crate's build. The Cargo command defaults to `build`; all
provided Cargo arguments are forwarded unchanged. For example:

```console
./test_build.sh linux-micro test/test-crate
./test_build.sh linux path/to/my-crate
./test_build.sh linux-micro /absolute/path/to/my-crate
./test_build.sh linux-micro test/test-crate test
./test_build.sh linux-micro test/test-crate doc --all-features
./test_build.sh linux-micro test/test-crate test --all-features
```

Rustwide itself runs in a Linux container and starts the build container through
the mounted Docker socket, so the host only needs Docker configured to run Linux
containers. The first run can take a few minutes while Rustwide initializes its
workspace and installs nightly; later runs reuse `.rustwide-test`.

[Crater]: https://github.com/rust-lang/crater
[docs.rs]: https://github.com/rust-lang/docs.rs
