ARG UBUNTU_VERSION=24.04

FROM ubuntu:${UBUNTU_VERSION} as base

LABEL maintainer="PunGrumpy <108584943+PunGrumpy@users.noreply.github.com>"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    TERM=xterm-256color \
    TZ=Asia/Bangkok

RUN apt update && apt install --yes \
    git \
    curl \
    wget \
    sudo \
    iputils-ping \
    build-essential \
    gcc \
    procps \
    && apt autoclean autopurge autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=pungrumpy
RUN useradd -m ${USERNAME} \
    && usermod -aG sudo ${USERNAME} \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}

WORKDIR /home/${USERNAME}

RUN curl -fsSL https://raw.githubusercontent.com/PunGrumpy/dotfiles/main/build.sh | bash -s

SHELL ["/home/linuxbrew/.linuxbrew/bin/fish", "-c"]

RUN curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source \ 
    && fisher install jorgebucaran/fisher \
    && fisher install ilancosman/tide@v5 \
    && fisher install jethrokuan/z \
    && fisher install PatrickF1/fzf.fish \
    && fisher install nickeb96/puffer-fish \
    && fisher install laughedelic/pisces

ENTRYPOINT ["/home/linuxbrew/.linuxbrew/bin/fish"]