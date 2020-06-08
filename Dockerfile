FROM ubuntu:focal

# Install the packages contained in `packages.txt`
COPY packages.txt /opt/crates-build-env/packages.txt
RUN apt-get update && cat /opt/crates-build-env/packages.txt | DEBIAN_FRONTEND=noninteractive xargs apt-get install -y

# Fix the "sudo: setrlimit(RLIMIT_CORE): Operation not permitted" error when
# starting up the container with `MAP_USER_ID`. Upstream issue:
#
#    https://github.com/sudo-project/sudo/issues/42
#
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

# Setup the entrypoint
COPY entrypoint.sh /opt/crates-build-env/entrypoint.sh
ENTRYPOINT ["/opt/crates-build-env/entrypoint.sh"]

CMD ["bash"]
