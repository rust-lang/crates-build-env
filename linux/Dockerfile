FROM ubuntu:noble

# Install the packages contained in `packages.txt`
COPY packages.txt /opt/crates-build-env/packages.txt
RUN apt-get update && \
    cat /opt/crates-build-env/packages.txt | DEBIAN_FRONTEND=noninteractive xargs apt-get install -y && \
    rm -rf /var/lib/apt/lists/*

RUN curl -LO https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-29/wasi-sdk-29.0-x86_64-linux.deb && \
    dpkg -i wasi-sdk-29.0-x86_64-linux.deb && \
    rm wasi-sdk-29.0-x86_64-linux.deb
ENV WASI_SDK_PATH=/opt/wasi-sdk

CMD ["bash"]
