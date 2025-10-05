#!/bin/bash
set -euxo pipefail

echo ">>> Configuring Flatpak remotes"

# Remove Fedora system remote if present
if flatpak remote-list | grep -q "^fedora"; then
  flatpak remote-delete --force fedora || true
fi

# Add official Flathub remote if missing
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Optionally verify setup
flatpak remotes

echo ">>> Flatpak remote configuration complete"
