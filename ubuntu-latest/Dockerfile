FROM ubuntu:20.10

LABEL org.opencontainers.image.title="Ubuntu Latest"
LABEL org.opencontainers.image.source="https://github.com/cubos/remote-images"

# Disable dialogs on apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Base Dependencies
RUN apt-get update && \
  apt-get dist-upgrade -y && \
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

# Enable bash color prompt over SSH
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /etc/skel/.bashrc

# Go
RUN \
  GO_PKG_VERSION=$(curl -s https://golang.org/dl/ | grep -Po 'go[0-9.]+linux-amd64' | head -n1) && \
  wget https://dl.google.com/go/${GO_PKG_VERSION}.tar.gz && \
  tar -xvf ${GO_PKG_VERSION}.tar.gz && \
  mv go /opt && \
  echo ' \
  export GOROOT="/opt/go" \
  export GOPATH="$HOME/go" \
  export PATH="$PATH:/opt/go/bin:/$HOME/go/bin" \
  ' > /etc/profile.d/go.sh

# Docker Repository
RUN \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Terraform Repository
RUN \
  curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
  apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Node Version Manager
RUN \
  VERSION=$(curl -sL https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r ".tag_name") && \
  mkdir /opt/nvm && \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${VERSION}/install.sh | METHOD=script NVM_DIR=/opt/nvm bash && \
  echo ' \
  . /opt/nvm/nvm.sh \
  export NVM_DIR="/opt/nvm" \
  ' > /etc/profile.d/nvm.sh

# Node.js
RUN \
  . /etc/profile.d/nvm.sh \
  nvm install 12 && \
  nvm install 14 && \
  nvm install 16 && \
  nvm alias default 14

# Install APT Packages
RUN apt-get install -y \
  containerd.io \
  docker-ce \
  docker-ce-cli \
  docker-compose \
  terraform
