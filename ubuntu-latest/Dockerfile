FROM ubuntu:20.10

LABEL org.opencontainers.image.title="Ubuntu Latest"
LABEL org.opencontainers.image.source="https://github.com/cubos/remote-images"

# Disable dialogs on apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Base Dependencies
RUN apt-get update && \
  apt-get install -y \
  curl \
  wget \
  software-properties-common \
  apt-transport-https \
  ca-certificates \
  gnupg \
  gnupg-agent \
  unzip \
  git \
  jq

# Full Ubuntu Server
RUN yes | unminimize

# Enable bach color prompt over SSH
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /etc/skel/.bashrc

# Go
RUN GO_PKG_VERSION=$(curl -s https://golang.org/dl/ | grep -Po 'go[0-9.]+linux-amd64' | head -n1) && \
  wget https://dl.google.com/go/${GO_PKG_VERSION}.tar.gz && \
  tar -xvf ${GO_PKG_VERSION}.tar.gz && \
  mv go /usr/local

# Docker Repository
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Terraform Repository
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
  apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Packages
RUN apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install -y \
  containerd.io \
  docker-ce \
  docker-ce-cli \
  docker-compose \
  terraform
