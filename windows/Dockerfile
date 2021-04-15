# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Install the Visual C++ Build tools
#
# Error code 3010 indicates a restart is required to complete installation, but
# the command was otherwise successful.
SHELL ["cmd", "/S", "/C"]
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --add "Microsoft.VisualStudio.Workload.VCTools"                `
    --includeRecommended                                           `
    || IF "%ERRORLEVEL%"=="3010" EXIT 0

SHELL ["powershell", "-ExecutionPolicy", "Bypass", "-Command"]

# Install chocolatey
RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install packages
#
# We need to get the new value of `$PATH` after `choco install`, but
# chocolatey's `refreshenv` won't be available until we restart the shell.
# Make `refreshenv` available right away, by importing the Chocolatey profile
# module. See https://stackoverflow.com/a/46760714.
COPY choco-packages.txt C:\
RUN $ErrorActionPreference = 'Stop';                                           `
    choco install -y @(Get-Content C:\choco-packages.txt);                     `
    Import-Module "C:\ProgramData\chocolatey\helpers\chocolateyProfile.psm1";  `
    refreshenv

# Install vcpkg
ADD https://github.com/Microsoft/vcpkg/archive/master.zip C:\TEMP\vcpkg-master.zip
RUN $ErrorActionPreference = 'Stop';                                  `
    Expand-Archive -Path C:\TEMP\vcpkg-master.zip -DestinationPath .; `
    rm C:\TEMP\vcpkg-master.zip;                                      `
    cd .\vcpkg-master;                                                `
    .\bootstrap-vcpkg.bat;                                            `
    .\vcpkg integrate install

# Install C libraries
#
# The `vcpkg` crate searches for libraries matching the target architecture
# exactly. It won't use x86 libraries on a 64-bit system. Setting the default
# triplet tells `vcpkg` to install 64-bit versions.
ENV VCPKG_DEFAULT_TRIPLET=x64-windows
COPY vc-packages.txt C:\
RUN .\vcpkg-master\vcpkg install @(Get-Content C:\vc-packages.txt)

# Tell the `vcpkg` crate to generate dynamically linked executables
ENV VCPKGRS_DYNAMIC=1

CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
