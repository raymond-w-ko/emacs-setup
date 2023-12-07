#!/bin/bash -ex

apt-get install locales && locale-gen en_US.UTF-8
apt-get install \
    adwaita-icon-theme-full \
    apache2-utils \
    aspell \
    aspell-en \
    autoconf \
    ccache \
    cmake \
    curl \
    dconf-editor \
    devscripts \
    equivs \
    exa \
    fd-find \
    fonts-dejavu \
    fonts-noto-color-emoji \
    fonts-urw-base35 \
    fortune \
    fortune-mod diffutils \
    g++-12 \
    gcc-12 \
    gdb \
    git \
    git-lfs \
    gnome-tweaks \
    gnupg \
    hicolor-icon-theme \
    less \
    libgccjit-12-dev \
    libgccjit0 \
    libgccjit0 \
    libgif-dev \
    libgnutls28-dev \
    libgtk-3-0 \
    libgtk-3-dev \
    libharfbuzz-bin \
    libharfbuzz-dev \
    libjansson-dev \
    libjansson4 \
    libjpeg-dev \
    libjpeg-turbo8-dev \
    libm17n-0 \
    libncurses5-dev \
    libotf-bin \
    libotf-dev \
    libpng-dev \
    libprotobuf-dev \
    libssl-dev \
    libtiff-dev \
    libtool \
    libtool-bin \
    libtree-sitter-dev \
    libvterm-bin \
    libvterm-dev \
    libvterm0 \
    libwebkit2gtk-4.0 \
    libwebkit2gtk-4.0-dev \
    libwebp-dev \
    libxpm-dev \
    make \
    menu \
    menu-xdg \
    ncurses-term \
    openjdk-17-jdk \
    openssh-server \
    pkg-config \
    protobuf-compiler \
    python3 \
    python3-dev \
    python3-paramiko \
    python3-pip \
    python3-pyinotify \
    python3-rencode \
    python3-setuptools \
    python3-xdg \
    rclone \
    ripgrep \
    software-properties-common \
    sqlite3 \
    ssh-askpass zsh \
    sudo \
    sudo \
    supervisor \
    texinfo \
    tmux \
    tzdata \
    unzip \
    wget \
    wget \
    x11-apps \
    x11-xserver-utils \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-base \
    xfonts-utils \
    xterm \
    zstd \
    -y --no-install-recommends

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 10
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 10
