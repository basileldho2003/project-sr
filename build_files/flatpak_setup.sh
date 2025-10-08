#!/bin/bash
set -euxo pipefail

echo ">>> Configuring Flatpak remotes (final persistent setup)"

# Clean up Fedora remotes and services if they exist
if flatpak --system remotes | grep -q '^fedora'; then
  flatpak --system remote-delete --force fedora || true
fi

if flatpak --system remotes | grep -q '^fedora-testing'; then
  flatpak --system remote-delete --force fedora-testing || true
fi

# Mask Fedora flatpak repo service if present
if systemctl list-unit-files | grep -q flatpak-add-fedora-repos.service; then
  systemctl disable flatpak-add-fedora-repos.service || true
  systemctl mask flatpak-add-fedora-repos.service || true
fi
rm -f /usr/lib/systemd/system/flatpak-add-fedora-repos.service || true
rm -f /usr/etc/systemd/system/multi-user.target.wants/flatpak-add-fedora-repos.service || true

# Ensure Flathub .flatpakrepo exists in immutable /usr/etc (baked in image)
mkdir -p /usr/etc/flatpak/remotes.d
if [ ! -f /usr/etc/flatpak/remotes.d/flathub.flatpakrepo ]; then
  echo "Downloading Flathub repo definition..."
  curl -L -o /usr/etc/flatpak/remotes.d/flathub.flatpakrepo \
       https://dl.flathub.org/repo/flathub.flatpakrepo
fi

# Seed runtime remotes (persistent in /var)
mkdir -p /var/lib/flatpak/remotes.d
cp -a /usr/etc/flatpak/remotes.d/flathub.flatpakrepo /var/lib/flatpak/remotes.d/

# Mark as initialized for Universal Blue logic
mkdir -p /var/lib/flatpak
touch /var/lib/flatpak/.ublue-initialized

# Verify
echo ">>> Current Flatpak remotes:"
flatpak --system remotes || true

echo ">>> Flatpak remote configuration complete"
