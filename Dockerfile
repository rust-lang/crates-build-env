FROM debian:stretch

# Install the packages contained in `packages.txt`
COPY packages.txt /opt/crates-build-env/packages.txt
RUN apt-get update && cat /opt/crates-build-env/packages.txt | DEBIAN_FRONTEND=noninteractive xargs apt-get install -y

# Install the packages contained in `packages-backports.txt`
RUN echo "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list
COPY packages-backports.txt /opt/crates-build-env/packages-backports.txt
RUN apt-get update && cat /opt/crates-build-env/packages-backports.txt | DEBIAN_FRONTEND=noninteractive xargs apt-get install -t stretch-backports -y

# Setup the entrypoint
COPY entrypoint.sh /opt/crates-build-env/entrypoint.sh
ENTRYPOINT ["/opt/crates-build-env/entrypoint.sh"]

CMD ["bash"]
