#!/bin/bash
set -ouex pipefail

echo ">>> Installing Cinnamon Desktop + LightDM"

# Install Cinnamon DE + LightDM + Slick Greeter
dnf5 install -y \
    @cinnamon-desktop-environment \
    lightdm \
    slick-greeter \
    xorg-x11-server-Xorg

# Disable other display managers if present
for dm in gdm.service sddm.service lxdm.service; do
    if systemctl list-unit-files | grep -q "$dm"; then
        systemctl disable "$dm"
    fi
done

# Enable LightDM
systemctl enable lightdm.service

# If we shipped local SELinux policy sources, compile & load them
for te in /usr/share/selinux/packages/my-*.te; do
  [ -f "$te" ] || continue
  base="$(basename "$te" .te)"
  checkmodule -M -m -o "/tmp/${base}.mod" "$te"
  semodule_package -o "/tmp/${base}.pp" -m "/tmp/${base}.mod"
  semodule -i "/tmp/${base}.pp" || true
done

echo ">>> Cinnamon + LightDM setup complete"
