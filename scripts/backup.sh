#!/bin/bash
# =============================================================================
# backup.sh — Automated backup with compression, rotation and logging
# Author: Nerea Arce | github.com/arcenerea
# =============================================================================

# --- Configuration ---
SOURCE="${HOME}/Documents"
DEST="${HOME}/backups"
RETENTION=7
LOG_FILE="${DEST}/backup.log"

# --- Setup ---
mkdir -p "$DEST"

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE="${DEST}/backup_${TIMESTAMP}.tar.gz"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# --- Run backup ---
log "Starting backup: ${SOURCE} → ${ARCHIVE}"

if tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")" 2>>"$LOG_FILE"; then
  SIZE=$(du -sh "$ARCHIVE" | cut -f1)
  log "Backup completed successfully. Size: ${SIZE}"
else
  log "ERROR: Backup failed."
  exit 1
fi

# --- Rotation: keep last N backups ---
BACKUP_COUNT=$(ls -1 "${DEST}"/backup_*.tar.gz 2>/dev/null | wc -l)

if [ "$BACKUP_COUNT" -gt "$RETENTION" ]; then
  DELETE_COUNT=$((BACKUP_COUNT - RETENTION))
  log "Rotating old backups — removing ${DELETE_COUNT} file(s)..."
  ls -1t "${DEST}"/backup_*.tar.gz | tail -n "$DELETE_COUNT" | while read -r OLD; do
    rm -f "$OLD"
    log "Deleted: ${OLD}"
  done
fi

log "Done. Total backups kept: $(ls -1 "${DEST}"/backup_*.tar.gz 2>/dev/null | wc -l)/${RETENTION}"
