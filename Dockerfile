FROM debian:stretch

# Install the packages contained in `packages.txt`
COPY packages.txt /opt/crates-build-env/packages.txt
RUN apt-get update && cat /opt/crates-build-env/packages.txt | DEBIAN_FRONTEND=noninteractive xargs apt-get install -y
