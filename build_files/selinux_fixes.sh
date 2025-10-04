#!/bin/bash
set -euxo pipefail

echo ">>> Applying SELinux fcontext fixes"

# --- LightDM .dmrc files ---
# Users can live in /home or /var/home depending on setup (Fedora Silverblue, uBlue, etc.)
semanage fcontext -a -t xdm_home_t '/home/[^/]+/.dmrc'
semanage fcontext -a -t xdm_home_t '/var/home/[^/]+/.dmrc'

# --- tuned config directory ---
# tuned-ppd needs to write/search inside /etc/tuned
semanage fcontext -a -t tuned_rw_etc_t '/etc/tuned(/.*)?'

# --- Plymouth boot log ---
# logrotate must be able to stat/read this
semanage fcontext -a -t plymouthd_var_log_t '/var/log/boot.log'

# Apply changes immediately
restorecon -Rv /home || true
restorecon -Rv /var/home || true
restorecon -Rv /etc/tuned || true
restorecon -v /var/log/boot.log || true

echo ">>> SELinux fcontext fixes applied"
