#!/bin/bash
set -euxo pipefail

echo ">>> Configuring Flatpak remotes (command-based setup)"

# ---------------------------------------------------------------------
# Remove Fedora OCI remotes only if they exist
# ---------------------------------------------------------------------
if flatpak --system remotes | grep -q '^fedora'; then
    echo "Removing Fedora Flatpak remote..."
    flatpak --system remote-delete fedora || true
fi

if flatpak --system remotes | grep -q '^fedora-testing'; then
    echo "Removing Fedora-testing Flatpak remote..."
    flatpak --system remote-delete fedora-testing || true
fi

# ---------------------------------------------------------------------
# Add Flathub remote if missing
# ---------------------------------------------------------------------
if ! flatpak --system remotes | grep -q '^flathub'; then
    echo "Adding Flathub Flatpak remote..."
    flatpak --system remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
else
    echo "Flathub remote already exists — skipping."
fi

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
