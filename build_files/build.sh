#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux
dnf5 install -y \
  @cinnamon-desktop \
  lightdm slick-greeter-cinnamon tmux hello

systemctl enable lightdm.service

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

dnf5 -y copr enable ublue-os/packages
dnf5 -y --enablerepo copr:copr.fedorainfracloud.org:ublue-os:packages install ublue-brew
dnf5 -y copr disable ublue-os/packages

rm -rf /var/run
ln -sfn ../run /var/run

dnf5 clean all

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable brew-bootstrap.service
