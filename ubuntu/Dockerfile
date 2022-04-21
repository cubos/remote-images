FROM ubuntu:21.10

LABEL org.opencontainers.image.title="Ubuntu"
LABEL org.opencontainers.image.source="https://github.com/cubos/remote-images"

# Disable dialogs on apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Base Dependencies
RUN \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install -y \
  build-essential \
  apt-transport-https \
  ca-certificates \
  curl \
  git \
  gnupg \
  gnupg-agent \
  jq \
  libncurses5 \
  software-properties-common \
  unzip \
  xz-utils

# Full Ubuntu Server
RUN yes | unminimize

# Git PPA
RUN add-apt-repository -y ppa:git-core/ppa

# Go PPA
RUN add-apt-repository -y ppa:longsleep/golang-backports

# Docker Repository
RUN \
  curl -sSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Docker Compose Switch (compatibility with Docker Compose v1)
RUN \
  VERSION=$(curl -sSL https://api.github.com/repos/docker/compose-switch/releases/latest | jq -r ".tag_name") && \
  curl -sSL "https://github.com/docker/compose-switch/releases/download/${VERSION}/docker-compose-linux-amd64" -o /usr/local/bin/docker-compose && \
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
  ' > /etc/profile.d/rust.sh && \
  . /etc/profile.d/rust.sh && \
  rustup component add rust-analysis --toolchain stable-x86_64-unknown-linux-gnu && \
  rustup component add rust-src --toolchain stable-x86_64-unknown-linux-gnu && \
  rustup component add rls --toolchain stable-x86_64-unknown-linux-gnu && \
  chown -R 1000:1000 /opt/cargo && \
  chown -R 1000:1000 /opt/rustup

# Node.js
RUN \
  VERSION=$(curl -sSL https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r ".tag_name") && \
  mkdir /opt/nvm && \
  curl -sSL https://raw.githubusercontent.com/nvm-sh/nvm/${VERSION}/install.sh | METHOD=script NVM_DIR=/opt/nvm bash && \
  echo ' \
  export NVM_DIR="/opt/nvm" && \
  . /opt/nvm/nvm.sh \
  ' > /etc/profile.d/nvm.sh && \
  . /etc/profile.d/nvm.sh && \
  nvm install 12 && \
  nvm install 14 && \
  nvm install 16 && \
  nvm install 17 && \
  nvm install 18 && \
  nvm use 12 && npm i -g npm && \
  nvm use 14 && npm i -g npm && \
  nvm use 16 && npm i -g npm && \
  nvm use 17 && npm i -g npm && \
  nvm use 18 && npm i -g npm && \
  nvm alias default 16 && \
  chown -R 1000:1000 /opt/nvm

# Google Cloud SDK
RUN \
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
  tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# AWS SDK
RUN \
  curl -sSLO https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
  unzip -q awscli-exe-linux-x86_64.zip && \
  ./aws/install && \
  rm -rf awscli-exe-linux-x86_64.zip aws

# VSCode LiveShare libs
RUN curl -sSL https://aka.ms/vsls-linux-prereq-script | bash -

# .NET
RUN curl -sSLO https://packages.microsoft.com/config/ubuntu/20.10/packages-microsoft-prod.deb && \
  dpkg -i packages-microsoft-prod.deb && \
  rm packages-microsoft-prod.deb

# LLVM and Clang
RUN VERSION=13 && \
  apt-get install -y \
  clang-${VERSION} \
  lld-${VERSION} \
  lldb-${VERSION} \
  libc++-${VERSION}-dev \
  libc++abi-${VERSION}-dev \
  clang-format-${VERSION} \
  clang-tools-${VERSION} && \
  update-alternatives --install /usr/bin/lld lld /usr/bin/lld-${VERSION} 100 && \
  update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-${VERSION} 100 && \
  update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-${VERSION} 100 && \
  update-alternatives --install /usr/bin/clang clang /usr/bin/clang-${VERSION} 100 && \
  update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-${VERSION} 100

# Flutter
RUN VERSION=$(curl -sSL https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json | jq -r '.releases | map(select(.channel == "stable"))[0].version') && \
  curl -sSLO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${VERSION}-stable.tar.xz && \
  tar -xf flutter_linux_${VERSION}-stable.tar.xz && \
  rm flutter_linux_${VERSION}-stable.tar.xz && \
  mv flutter /opt && \
  /opt/flutter/bin/flutter config --machine --no-analytics && \
  /opt/flutter/bin/flutter precache && \
  echo ' \
  export PATH="$PATH:/opt/flutter/bin" \
  ' > /etc/profile.d/flutter.sh && \
  chown -R 1000:1000 /opt/flutter

# Google Chrome (Flutter Web needs it)
RUN curl -sSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | \
  tee -a /etc/apt/sources.list.d/google-chrome.list

# Crystal
RUN curl -sSL https://crystal-lang.org/install.sh | bash

# Wasmer
RUN curl https://get.wasmer.io -sSL | WASMER_DIR=/opt/wasmer sh && \
  echo ' \
  export WASMER_DIR="/opt/wasmer" && \
  [ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh" \
  ' > /etc/profile.d/wasmer.sh

# Wasmtime
RUN curl https://wasmtime.dev/install.sh -sSL | WASMTIME_HOME=/opt/wasmtime bash && \
  echo ' \
  export WASMTIME_HOME="/opt/wasmtime" && \
  export PATH="$PATH:/opt/wasmtime/bin" \
  ' > /etc/profile.d/wasmtime.sh

# Install APT Packages
RUN \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install -y \
  bash-completion \
  binaryen \
  containerd.io \
  dialog \
  dnsutils \
  docker-ce \
  docker-ce-cli \
  docker-compose-plugin \
  dotnet-sdk-2.1 \
  dotnet-sdk-3.1 \
  dotnet-sdk-5.0 \
  dotnet-sdk-6.0 \
  golang \
  google-chrome-stable \
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
  graphviz \
  intltool \
  iputils-ping \
  kubectl \
  language-pack-en \
  language-pack-pt \
  less \
  libfreetype6 \
  libreadline-dev \
  libxext6 \
  libxi6 \
  libxrender1 \
  libxtst6 \
  lsof \
  lzip \
  man \
  mono-devel \
  moreutils \
  nano \
  net-tools \
  openssh-server \
  p7zip-full \
  perl \
  php-cli \
  python \
  python3 \
  python3-cryptography \
  python3-netifaces \
  python3-pip \
  rsync \
  rsyslog \
  ruby \
  ruby-dev \
  screen \
  socat \
  strace \
  sudo \
  terraform \
  vim \
  wabt \
  wget \
  xz-utils \
  zsh

# Disable kernel logs on rsyslog
RUN sed -i -E 's/(module\(load="imklog")/# \1/' /etc/rsyslog.conf

# Update gems
RUN \
  gem update && gem cleanup

# Get rid of the "take a quick anonymous survey" message
RUN gcloud --version

# Update pip
RUN python3 -m pip install -U pip

# Install projector
RUN pip3 install projector-installer
