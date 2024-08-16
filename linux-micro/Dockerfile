FROM ubuntu:jammy

# Install the packages contained in `packages.txt`
COPY packages.txt /opt/crates-build-env/packages.txt
RUN apt-get update && \
    cat /opt/crates-build-env/packages.txt | DEBIAN_FRONTEND=noninteractive xargs apt-get install -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install the up-to-date version of CMake
RUN CMAKE_VERSION="3.30.2" ARCH=$(uname -m) && \
    curl -s -O -L https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-${ARCH}.sh && \
    mkdir /opt/cmake && \
    sh cmake-${CMAKE_VERSION}-linux-${ARCH}.sh --skip-license --prefix=/opt/cmake && \
    ln -sf /opt/cmake/bin/cmake /usr/local/bin/cmake && \
    ln -sf /opt/cmake/bin/ccmake /usr/local/bin/ccmake && \
    ln -sf /opt/cmake/bin/cpack /usr/local/bin/cpack && \
    ln -sf /opt/cmake/bin/ctest /usr/local/bin/ctest && \
    rm -rf /opt/cmake/doc && \
    rm -f cmake-${CMAKE_VERSION}-linux-${ARCH}.sh

CMD ["bash"]
