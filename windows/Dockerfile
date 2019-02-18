# escape=`

ARG BASE_IMAGE_VER=:1803

FROM mcr.microsoft.com/windows/servercore${BASE_IMAGE_VER}

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

SHELL ["powershell", "-Command"]

# Install vcpkg
ADD https://github.com/Microsoft/vcpkg/archive/master.zip C:\TEMP\vcpkg-master.zip
RUN $ErrorActionPreference = 'Stop';                                  `
    Expand-Archive -Path C:\TEMP\vcpkg-master.zip -DestinationPath .; `
    cd .\vcpkg-master;                                                `
    .\bootstrap-vcpkg.bat;                                            `
    .\vcpkg integrate install

# Install packages
COPY vc-packages.txt C:\
RUN .\vcpkg-master\vcpkg install @(Get-Content C:\vc-packages.txt)

CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
