FROM fedora:34

LABEL org.opencontainers.image.title="Fedora"
LABEL org.opencontainers.image.source="https://github.com/cubos/remote-images"

# Base Dependencies
RUN \
  dnf install 'dnf-command(config-manager)' -y

# Docker Repository
RUN \
  dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo && \
  dnf makecache

# Install packages
RUN \
  dnf install -y \
  docker-ce \
  git
