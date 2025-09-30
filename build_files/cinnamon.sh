#!/bin/bash
set -ouex pipefail

# Install Cinnamon DE + LightDM + Slick Greeter
dnf5 install -y \
    @cinnamon-desktop-environment \
    lightdm \
    slick-greeter

# Disable other display managers (if they exist)
systemctl disable gdm.service || true
systemctl disable sddm.service || true
systemctl disable lxdm.service || true

# Enable LightDM
systemctl enable lightdm.service

install -d -m 0755 -o root -g root /var/cache/lightdm
install -d -m 0750 -o lightdm -g lightdm /var/lib/lightdm-data
