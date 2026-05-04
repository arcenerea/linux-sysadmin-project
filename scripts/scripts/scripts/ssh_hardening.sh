#!/bin/bash
# =============================================================================
# ssh_hardening.sh — Automated SSH secure configuration
# Author: Nerea Arce | github.com/arcenerea
# =============================================================================

SSH_CONFIG="/etc/ssh/sshd_config"
BACKUP="${SSH_CONFIG}.backup_$(date +%Y-%m-%d_%H-%M-%S)"
LOG_FILE="/var/log/ssh_hardening.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo ./ssh_hardening.sh"
    exit 1
  fi
}

backup_config() {
  cp "$SSH_CONFIG" "$BACKUP"
  log "Original config backed up to: ${BACKUP}"
  echo "Backup saved: ${BACKUP}"
}

set_param() {
  PARAM=$1
  VALUE=$2

  if grep -q "^${PARAM}" "$SSH_CONFIG"; then
    sed -i "s/^${PARAM}.*/${PARAM} ${VALUE}/" "$SSH_CONFIG"
  elif grep -q "^#${PARAM}" "$SSH_CONFIG"; then
    sed -i "s/^#${PARAM}.*/${PARAM} ${VALUE}/" "$SSH_CONFIG"
  else
    echo "${PARAM} ${VALUE}" >> "$SSH_CONFIG"
  fi
  log "Set: ${PARAM} ${VALUE}"
}

# --- Main ---
check_root

echo "==============================="
echo "   SSH Hardening"
echo "   $(date '+%Y-%m-%d %H:%M:%S')"
echo "==============================="
echo ""

backup_config

echo "Applying security settings..."
echo ""

set_param "PermitRootLogin" "no"
echo "✔ PermitRootLogin → no"

set_param "PasswordAuthentication" "no"
echo "✔ PasswordAuthentication → no"

set_param "PubkeyAuthentication" "yes"
echo "✔ PubkeyAuthentication → yes"

set_param "ClientAliveInterval" "300"
echo "✔ ClientAliveInterval → 300"

set_param "ClientAliveCountMax" "2"
echo "✔ ClientAliveCountMax → 2"

set_param "MaxAuthTries" "3"
echo "✔ MaxAuthTries → 3"

set_param "LoginGraceTime" "30"
echo "✔ LoginGraceTime → 30"

set_param "X11Forwarding" "no"
echo "✔ X11Forwarding → no"

set_param "AllowTcpForwarding" "no"
echo "✔ AllowTcpForwarding → no"

set_param "Protocol" "2"
echo "✔ Protocol → 2"

echo ""
echo "Restarting SSH service..."
if systemctl restart sshd; then
  log "SSH service restarted successfully."
  echo "✔ SSH service restarted."
else
  log "ERROR: Could not restart SSH service."
  echo "✘ ERROR: Could not restart SSH service. Check manually."
  exit 1
fi

echo ""
echo "==============================="
echo "SSH hardening completed."
echo "Original config backed up to:"
echo "${BACKUP}"
echo "==============================="
log "SSH hardening completed successfully."
