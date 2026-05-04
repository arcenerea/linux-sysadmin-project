#!/bin/bash
# =============================================================================
# user_manager.sh — User creation, deletion, group and sudoers management
# Author: Nerea Arce | github.com/arcenerea
# =============================================================================

LOG_FILE="/var/log/user_manager.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo ./user_manager.sh"
    exit 1
  fi
}

create_user() {
  read -rp "Username: " USERNAME
  read -rp "Full name: " FULLNAME
  read -rp "Shell (default: /bin/bash): " SHELL
  SHELL=${SHELL:-/bin/bash}

  if id "$USERNAME" &>/dev/null; then
    log "ERROR: User ${USERNAME} already exists."
    return 1
  fi

  useradd -m -c "$FULLNAME" -s "$SHELL" "$USERNAME"
  passwd "$USERNAME"
  log "User created: ${USERNAME} (${FULLNAME}), shell: ${SHELL}"
  echo "User ${USERNAME} created successfully."
}

delete_user() {
  read -rp "Username to delete: " USERNAME

  if ! id "$USERNAME" &>/dev/null; then
    log "ERROR: User ${USERNAME} does not exist."
    return 1
  fi

  read -rp "Remove home directory? (y/n): " REMOVE_HOME
  if [ "$REMOVE_HOME" = "y" ]; then
    userdel -r "$USERNAME"
    log "User deleted (with home): ${USERNAME}"
  else
    userdel "$USERNAME"
    log "User deleted (home kept): ${USERNAME}"
  fi
  echo "User ${USERNAME} deleted."
}

add_to_group() {
  read -rp "Username: " USERNAME
  read -rp "Group: " GROUP

  if ! id "$USERNAME" &>/dev/null; then
    log "ERROR: User ${USERNAME} does not exist."
    return 1
  fi

  if ! getent group "$GROUP" &>/dev/null; then
    log "ERROR: Group ${GROUP} does not exist."
    return 1
  fi

  usermod -aG "$GROUP" "$USERNAME"
  log "User ${USERNAME} added to group ${GROUP}"
  echo "Done."
}

manage_sudo() {
  read -rp "Username: " USERNAME
  read -rp "Grant or revoke sudo? (grant/revoke): " ACTION

  if ! id "$USERNAME" &>/dev/null; then
    log "ERROR: User ${USERNAME} does not exist."
    return 1
  fi

  if [ "$ACTION" = "grant" ]; then
    usermod -aG sudo "$USERNAME"
    log "Sudo granted to: ${USERNAME}"
    echo "Sudo access granted to ${USERNAME}."
  elif [ "$ACTION" = "revoke" ]; then
    gpasswd -d "$USERNAME" sudo
    log "Sudo revoked from: ${USERNAME}"
    echo "Sudo access revoked from ${USERNAME}."
  else
    echo "Invalid option. Use 'grant' or 'revoke'."
  fi
}

# --- Menu ---
check_root

echo ""
echo "==============================="
echo "   Linux User Manager"
echo "==============================="
echo "1) Create user"
echo "2) Delete user"
echo "3) Add user to group"
echo "4) Manage sudo access"
echo "5) Exit"
echo "==============================="
read -rp "Select option: " OPTION

case $OPTION in
  1) create_user ;;
  2) delete_user ;;
  3) add_to_group ;;
  4) manage_sudo ;;
  5) exit 0 ;;
  *) echo "Invalid option." ;;
esac
