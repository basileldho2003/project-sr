#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y hello perl-core @development-tools

# Use a COPR Example:
#
dnf5 -y copr enable ublue-os/staging

dnf5 -y copr enable ublue-os/packages

dnf5 -y install ublue-brew uupd

# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl disable rpm-ostreed-automatic.timer
systemctl disable flatpak-system-update.timer
systemctl --global disable flatpak-user-update.timer
systemctl disable brew-update.timer
systemctl disable brew-upgrade.timer
systemctl mask systemd-remount-fs.service
systemctl enable uupd.timer
systemctl enable podman.socket
systemctl --global enable brew-once.service

dnf5 clean all
rm -rf /var/cache/dnf /var/lib/dnf
