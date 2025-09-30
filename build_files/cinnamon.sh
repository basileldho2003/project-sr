#!/bin/bash
set -ouex pipefail

# Install Cinnamon DE + LightDM + Slick Greeter
dnf5 install -y \
    @cinnamon-desktop-environment \
    lightdm \
    slick-greeter

# Enable LightDM
systemctl enable lightdm.service

install -d -m 0755 /var/cache/lightdm
install -d -m 0750 /var/lib/lightdm-data
