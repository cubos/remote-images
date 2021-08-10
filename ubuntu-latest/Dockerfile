FROM ubuntu:21.04

LABEL org.opencontainers.image.title="Ubuntu Latest"
LABEL org.opencontainers.image.source="https://github.com/cubos/remote-images"

# Disable dialogs on apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Base Dependencies
RUN \
  apt-get update && \
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
  jq \
  xz-utils

# Full Ubuntu Server
RUN yes | unminimize

# Go
RUN \
  GO_PKG_VERSION=$(curl -sSL https://golang.org/dl/ | grep -Po "go[0-9.]+linux-$(dpkg --print-architecture)" | head -n1) && \
  wget -q https://dl.google.com/go/${GO_PKG_VERSION}.tar.gz && \
  tar -xf ${GO_PKG_VERSION}.tar.gz && \
  rm ${GO_PKG_VERSION}.tar.gz && \
  mv go /opt && \
  echo ' \
  export GOROOT="/opt/go" && \
  export GOPATH="$HOME/go" && \
  export PATH="$PATH:/opt/go/bin:/$HOME/go/bin" \
  ' > /etc/profile.d/go.sh

# Git PPA
RUN add-apt-repository -y ppa:git-core/ppa

# Docker Repository
RUN \
  curl -sSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Docker Compose
RUN \
  VERSION=$(curl -sSL https://api.github.com/repos/docker/compose/releases/latest | jq -r ".tag_name") && \
  curl -sSL "https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose

# Terraform Repository
RUN \
  curl -sSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
  apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Rust
RUN \
  export RUSTUP_HOME="/opt/rustup" && \
  export CARGO_HOME="/opt/cargo" && \
  curl -sSL https://sh.rustup.rs | sh -s -- --no-modify-path -y && \
  echo ' \
  export RUSTUP_HOME="/opt/rustup" && \
  export CARGO_HOME="/opt/cargo" && \
  export PATH="$PATH:/opt/cargo/bin" \
  ' > /etc/profile.d/rust.sh

# Node.js (Node Package Manager)
RUN \
  VERSION=$(curl -sSL https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r ".tag_name") && \
  mkdir /opt/nvm && \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${VERSION}/install.sh | METHOD=script NVM_DIR=/opt/nvm bash && \
  echo ' \
  export NVM_DIR="/opt/nvm" && \
  . /opt/nvm/nvm.sh \
  ' > /etc/profile.d/nvm.sh

# Node.js
RUN \
  . /etc/profile.d/nvm.sh && \
  nvm install 12 && \
  nvm install 14 && \
  nvm install 16 && \
  nvm alias default 14

# Google Cloud SDK
RUN \
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
  tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# AWS SDK
RUN \
  wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
  unzip awscli-exe-linux-x86_64.zip && \
  ./aws/install && \
  rm -rf awscli-exe-linux-x86_64.zip aws

# .NET
RUN wget https://packages.microsoft.com/config/ubuntu/20.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
  dpkg -i packages-microsoft-prod.deb && \
  rm packages-microsoft-prod.deb

# Flutter
RUN VERSION=$(curl -s https://storage.googleapis.com/flutter_infra/releases/releases_linux.json | jq -r '.releases | map(select(.channel == "stable"))[0].version') && \
  wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_${VERSION}-stable.tar.xz && \
  tar -xf flutter_linux_${VERSION}-stable.tar.xz && \
  rm flutter_linux_${VERSION}-stable.tar.xz && \
  mv flutter /opt && \
  /opt/flutter/bin/flutter config --machine --no-analytics && \
  /opt/flutter/bin/flutter precache && \
  echo ' \
  export PATH="$PATH:/opt/flutter/bin" \
  ' > /etc/profile.d/flutter.sh

# Google Chrome (Flutter Web needs it)
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
  apt-get install -y --no-install-recommends ./google-chrome-stable_current_amd64.deb && \
  rm google-chrome-stable_current_amd64.deb

# Install APT Packages
RUN \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install -y \
  build-essential \
  containerd.io \
  docker-ce \
  docker-ce-cli \
  dotnet-sdk-2.1 \
  dotnet-sdk-3.1 \
  dotnet-sdk-5.0 \
  google-cloud-sdk \
  google-cloud-sdk-app-engine-go \
  google-cloud-sdk-app-engine-java \
  google-cloud-sdk-app-engine-python \
  google-cloud-sdk-app-engine-python-extras \
  google-cloud-sdk-bigtable-emulator \
  google-cloud-sdk-cbt \
  google-cloud-sdk-cloud-build-local \
  google-cloud-sdk-datalab \
  google-cloud-sdk-datastore-emulator \
  google-cloud-sdk-firestore-emulator \
  google-cloud-sdk-pubsub-emulator \
  kubectl \
  python \
  python3 \
  python3-pip \
  sudo \
  terraform

# Get rid of the "take a quick anonymous survey" message
RUN gcloud --version
