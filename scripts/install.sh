#!/bin/sh

set -e

sudo dnf update --refresh -y

sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm \

sudo dnf copr enable -y lukenukem/asus-linux
sudo dnf copr enable -y observeroftime/betterdiscordctl

sudo dnf update --refresh -y

sudo dnf install -y \
    cmake \
    gcc-c++ \
    expat-devel \
    fontconfig-devel \
    libxcb-devel \
    freetype-devel \
    libxm12-devel \
    libxcrypt-compat \
    harfbuzz \
    kernel-devel \
    akmod-nvidia \
    xorg-x11-drv-nvidia-cuda \
    asusctl \
    supergfxctl \
    asusctl-rog-gui \
    openssl \
    ttf-mscorefonts \
    cabextract \
    xorg-x11-font-utils \
    fontconfig \
    dnf-automatic \
    gnome-themes-extra \
    cargo \
    flatpak \
    curl \
    wget \
    fd-find \
    ripgrep \
    fzf \
    zsh \
    neofetch \
    tldr \
    bat \
    cmatrix \
    neovim \
    npm \
    btop \
    pip \
    eza \
    qalc \
    lazygit \
    unrar \
    betterdiscordctl \
    xclip \
    asciinema

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y \
    com.github.tchx84.Flatseal \
    com.discordapp.Discord \
    com.google.Chrome \
    com.mattjakeman.ExtensionManager \
    com.spotify.Client \
    com.valvesoftware.Steam \
    com.protonvpn \
    org.telegram.desktop \
    org.qbittorrent.qBittorrent \
    org.mozilla.Thunderbird

sudo systemctl enable \
    dnf-automatic.timer \
    nvidia-hibernate.service \
    nvidia-suspend.service \
    nvidia-resume.service \
    nvidia-powerd.service \
    supergfxd.service

cargo install silicon

betterdiscordctl -i flatpak install

curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
spicetify config prefs_path ~/.var/app/com.spotify.Client/config/spotify/prefs
spicetify config spotify_path /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/
sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify
sudo chmod a+wr -R /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/Apps
