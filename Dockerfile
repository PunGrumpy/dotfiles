ARG UBUNTU_VERSION=24.04

FROM ubuntu:${UBUNTU_VERSION} as base

LABEL maintainer="PunGrumpy <108584943+PunGrumpy@users.noreply.github.com>"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    TERM=xterm-256color \
    TZ=Asia/Bangkok

RUN apt update && \
    apt install --yes \
    git \
    curl \
    wget \
    sudo \
    iputils-ping \
    build-essential \
    gcc \
    procps && \
    apt autoclean autopurge autoremove --yes && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/*

ARG USERNAME=pungrumpy
RUN useradd -m ${USERNAME} && \
    usermod -aG sudo ${USERNAME} && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}

WORKDIR /home/${USERNAME}

RUN curl -fsSL https://raw.githubusercontent.com/PunGrumpy/dotfiles/main/build.sh | bash -s

SHELL ["/home/linuxbrew/.linuxbrew/bin/fish", "-c"]

RUN curl -sL https://git.io/fisher | source && \
    fisher install jorgebucaran/fisher \
    ilancosman/tide@v5 \
    jethrokuan/z \
    PatrickF1/fzf.fish \
    nickeb96/puffer-fish \
    laughedelic/pisces

ENTRYPOINT ["/home/linuxbrew/.linuxbrew/bin/fish"]
