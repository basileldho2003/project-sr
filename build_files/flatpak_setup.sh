#!/bin/bash
set -euxo pipefail

echo ">>> Configuring Flatpak remotes (command-based setup)"

# Ensure Flatpak is installed (some uBlue images don’t ship it prebuilt)
if ! command -v flatpak &>/dev/null; then
    dnf5 install -y flatpak
fi

# Initialize flatpak (ignore harmless errors inside container)
flatpak --system remote-delete --force fedora || true
flatpak --system remote-delete --force fedora-testing || true

# Add official Flathub repo
flatpak --system remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Optionally install preselected Flatpak apps (example: Firedragon)
# flatpak install -y flathub org.garudalinux.firedragon || true

# Disable Fedora/uBlue auto Flatpak service
if systemctl list-unit-files | grep -q flatpak-add-fedora-repos.service; then
    systemctl disable flatpak-add-fedora-repos.service || true
    systemctl mask flatpak-add-fedora-repos.service || true
fi
rm -f /usr/lib/systemd/system/flatpak-add-fedora-repos.service || true
rm -f /usr/etc/systemd/system/multi-user.target.wants/flatpak-add-fedora-repos.service || true

# Prevent service from re-running on boot (uBlue-specific condition)
mkdir -p /var/lib/flatpak
touch /var/lib/flatpak/.ublue-initialized

# Verify the result
flatpak --system remotes || true

echo ">>> Flatpak remote configuration complete"
