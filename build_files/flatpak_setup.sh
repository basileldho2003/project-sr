#!/bin/bash
set -euxo pipefail

echo ">>> Configuring Flatpak remotes (final, lint-safe setup)"

# --------------------------------------------------------------------
# Remove Fedora remotes if they exist
# --------------------------------------------------------------------
if flatpak --system remotes | grep -q '^fedora'; then
  flatpak --system remote-delete --force fedora || true
fi

if flatpak --system remotes | grep -q '^fedora-testing'; then
  flatpak --system remote-delete --force fedora-testing || true
fi

# --------------------------------------------------------------------
# Mask Fedora’s auto Flatpak repo service (to stop OCI remotes)
# --------------------------------------------------------------------
if systemctl list-unit-files | grep -q flatpak-add-fedora-repos.service; then
  systemctl disable flatpak-add-fedora-repos.service || true
  systemctl mask flatpak-add-fedora-repos.service || true
fi

rm -f /usr/lib/systemd/system/flatpak-add-fedora-repos.service || true
rm -f /usr/etc/systemd/system/multi-user.target.wants/flatpak-add-fedora-repos.service || true

# --------------------------------------------------------------------
# Ensure Flathub repo definition exists under /etc (bootc-merge-safe)
# --------------------------------------------------------------------
mkdir -p /etc/flatpak/remotes.d
if [ ! -f /etc/flatpak/remotes.d/flathub.flatpakrepo ]; then
  echo "Downloading Flathub repo definition..."
  curl -L -o /etc/flatpak/remotes.d/flathub.flatpakrepo \
       https://dl.flathub.org/repo/flathub.flatpakrepo
else
  echo "Flathub repo already present in /etc/flatpak/remotes.d"
fi

# --------------------------------------------------------------------
# Seed runtime remotes in /var (persistent runtime layer)
# --------------------------------------------------------------------
mkdir -p /var/lib/flatpak/remotes.d
cp -a /etc/flatpak/remotes.d/flathub.flatpakrepo /var/lib/flatpak/remotes.d/

# Mark as initialized for Universal Blue logic
mkdir -p /var/lib/flatpak
touch /var/lib/flatpak/.ublue-initialized

# --------------------------------------------------------------------
# Verify result
# --------------------------------------------------------------------
echo ">>> Current Flatpak remotes:"
flatpak --system remotes || true

echo ">>> Flatpak remote configuration complete"
