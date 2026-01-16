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

# Copr
dnf5 -y copr enable avengemedia/dms
dnf5 -y copr enable wezfurlong/wezterm-nightly

# Package installation
dnf5 install -y nu steam
dnf5 install -y niri dms wezterm
dnf5 install -y google-roboto-fonts google-roboto-mono-font

# Group package installation
dnf5 group install development-tools
dnf5 group install system-tools
dnf5 group install virtualization

# System Unit Files
systemctl enable podman.socket
systemctl enable greetd
systemctl --user enable dms

dnf5 -y copr disable avengemedia/dms
dnf5 -y copr disable wezfurlong/wezterm-nightly