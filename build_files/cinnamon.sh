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

# If we shipped a local SELinux policy, compile & load it
if [ -f /usr/share/selinux/packages/my-cinnamon.te ]; then
  checkmodule -M -m -o /tmp/my-cinnamon.mod /usr/share/selinux/packages/my-cinnamon.te
  semodule_package -o /tmp/my-cinnamon.pp -m /tmp/my-cinnamon.mod
  semodule -i /tmp/my-cinnamon.pp || true
fi


echo ">>> Cinnamon + LightDM setup complete"
