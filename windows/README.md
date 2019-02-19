# Windows build environment for rust crates

This repository contains the source of a Docker container the Rust project uses
to build third-party crates on Windows. It is based on **Windows Server Core**,
and contains all the native dependencies used by the Rust crates we know of.

## Dependencies

All dependencies listed in `vc-packages.txt` will be installed into the
image with `vcpkg`.

## Using the docker image

This image must be run on a Windows host with both containerization and Hyper-V
enabled (Windows 10 Pro or Windows Server >=2016). If you wish to run `crater`
on an Azure VM, this requires a virtual machine image tagged with "v3".

The version of the base image can be configured by passing `--build-arg
BASE_IMAGE_VER=${YOUR_DESIRED_VERSION_NUMBER}` to `docker build`. It defaults
to `:1803` (note the leading colon) which specifies Windows Server Core,
version 1803.

Hyper-V can be enabled in [the GUI][hyperv] or in `Powershell` with:

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

A reboot is required for this to take effect.

[hyperv]: https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v#enable-the-hyper-v-role-through-settings


The Docker host must have a [build number][build] equal to that of the image
you wish to run (by default `mcr.microsoft.com/windows/servercore:1803`).

[Docker Desktop][] is required to run native Windows containers; this image
will not work with Docker Toolbox. Once installed, ensure that Docker Desktop
is configured to run Windows containers by right-clicking the icon in the
dock, or by running the following in `Powershell`:

```powershell
$Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon .
```

[Docker Desktop]: https://hub.docker.com/editions/community/docker-ce-desktop-windows
[build]: https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility
