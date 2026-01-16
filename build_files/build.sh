#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# COPR
dnf5 -y copr enable avengemedia/dms
dnf5 -y copr enable wezfurlong/wezterm-nightly

# Repositories
echo "[gemfury-nushell]
name=Gemfury Nushell Repo
baseurl=https://yum.fury.io/nushell/
enabled=1
gpgcheck=0
gpgkey=https://yum.fury.io/nushell/gpg.key" | tee /etc/yum.repos.d/fury-nushell.repo

echo "[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h" | tee /etc/yum.repos.d/vscodium.repo


# Package installation
dnf5 install -y \
    greetd nautilus nushell \
    niri dms wezterm google-roboto-fonts google-roboto-mono-fonts

# Group package installation
dnf5 group install development-tools -y
dnf5 group install system-tools -y 
dnf5 group install virtualization -y

# System Unit Files
systemctl enable podman.socket
# systemctl enable greetd
# systemctl --user enable dms

# Disable COPRs in the final image
dnf5 -y copr disable avengemedia/dms
dnf5 -y copr disable wezfurlong/wezterm-nightly