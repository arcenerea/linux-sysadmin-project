# 🐧 Linux System Administration Lab - Automatic Backup Script

**Author:** Nerea Arce  
**GitHub:** [arcenerea](https://github.com/arcenerea)  
**Date:** 2026

---

## Usage

Clone the repository and give execution permissions to any script:

```bash
git clone https://github.com/arcenerea/linux-sysadmin-toolkit
cd linux-sysadmin-toolkit
chmod +x scripts/*.sh
```

Each script can be run independently — see details below.

---

## Scripts in detail

### backup.sh
Automated backup with `tar` compression, timestamped archives and automatic rotation. Keeps the last 7 backups by default. Logs every operation.

```bash
./scripts/backup.sh
```

**Configurable variables:**
- `SOURCE` — folder to back up (default: `$HOME/Documents`)
- `DEST` — backup destination (default: `$HOME/backups`)
- `RETENTION` — number of backups to keep (default: 7)

---

### user_manager.sh
Interactive user management: create or delete users, assign groups and configure sudoers access. Logs every action with timestamp.

```bash
./scripts/user_manager.sh
```

**Options:**
- Create user with home directory and shell
- Delete user and optionally remove home directory
- Add user to existing group
- Grant or revoke sudo access

---

### system_health.sh
Generates a system health report: CPU usage, RAM consumption, disk space and top processes. Triggers an alert if any threshold is exceeded.

```bash
./scripts/system_health.sh
```

**Default thresholds:**
- CPU > 80%
- RAM > 85%
- Disk > 90%

---

### log_cleaner.sh
Cleans log files older than a configurable number of days. Supports dry-run mode to preview what would be deleted before actually removing anything.

```bash
./scripts/log_cleaner.sh
./scripts/log_cleaner.sh --dry-run
```

**Configurable variables:**
- `LOG_DIR` — directory to clean (default: `/var/log`)
- `RETENTION_DAYS` — delete logs older than N days (default: 30)

---

### ssh_hardening.sh
Applies SSH security best practices automatically: disables root login, disables password authentication, sets idle timeout and restricts access. Creates a backup of the original config before any changes.

```bash
sudo ./scripts/ssh_hardening.sh
```

**What it does:**
- Disables `PermitRootLogin`
- Disables `PasswordAuthentication`
- Sets `ClientAliveInterval` and `ClientAliveCountMax`
- Restarts SSH service safely

---

## Tech stack

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat-square&logo=gnubash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat-square&logo=linux&logoColor=black)

---

## Author

**Nerea Arce** — SysAdmin · DevOps · Cloud Infrastructure

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/nerea-arce/)
[![GitHub](https://img.shields.io/badge/GitHub-arcenerea-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/arcenerea)
