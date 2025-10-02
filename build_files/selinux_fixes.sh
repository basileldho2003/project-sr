#!/bin/bash
set -euxo pipefail

# ~/.dmrc should be xdm_home_t so LightDM can create/update it
semanage fcontext -a -t xdm_home_t '/home/[^/]+/.dmrc'

# tuned should be writable by tuned-ppd
semanage fcontext -a -t tuned_rw_etc_t '/etc/tuned(/.*)?'

# boot.log should be plymouthd_var_log_t so logrotate can stat/rotate it
semanage fcontext -a -t plymouthd_var_log_t '/var/log/boot.log'

# Apply now (safe even if files don't exist yet)
restorecon -Rv /home || true
restorecon -Rv /etc/tuned || true
restorecon -v /var/log/boot.log || true
