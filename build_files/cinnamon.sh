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
