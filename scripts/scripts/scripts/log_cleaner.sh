#!/bin/bash
# =============================================================================
# log_cleaner.sh — Automated log cleanup with configurable retention
# Author: Nerea Arce | github.com/arcenerea
# =============================================================================

# --- Configuration ---
LOG_DIR="/var/log"
RETENTION_DAYS=30
DRY_RUN=false

LOG_FILE="/var/log/log_cleaner.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# --- Parse arguments ---
for ARG in "$@"; do
  case $ARG in
    --dry-run) DRY_RUN=true ;;
    --dir=*) LOG_DIR="${ARG#*=}" ;;
    --days=*) RETENTION_DAYS="${ARG#*=}" ;;
  esac
done

echo "==============================="
echo "   Log Cleaner"
echo "   $(date '+%Y-%m-%d %H:%M:%S')"
echo "==============================="
echo "Directory : ${LOG_DIR}"
echo "Retention : ${RETENTION_DAYS} days"
echo "Mode      : $([ "$DRY_RUN" = true ] && echo 'DRY RUN' || echo 'LIVE')"
echo "==============================="
echo ""

if [ ! -d "$LOG_DIR" ]; then
  echo "ERROR: Directory ${LOG_DIR} does not exist."
  exit 1
fi

# --- Find and clean ---
DELETED=0
TOTAL_SIZE=0

while IFS= read -r FILE; do
  SIZE=$(du -sh "$FILE" 2>/dev/null | cut -f1)

  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] Would delete: ${FILE} (${SIZE})"
  else
    rm -f "$FILE"
    log "Deleted: ${FILE} (${SIZE})"
    echo "Deleted: ${FILE} (${SIZE})"
    DELETED=$((DELETED + 1))
  fi
done < <(find "$LOG_DIR" -type f -name "*.log" -mtime +"$RETENTION_DAYS")

echo ""
if [ "$DRY_RUN" = true ]; then
  echo "Dry run complete. No files were deleted."
  log "Dry run completed."
else
  echo "==============================="
  echo "Files deleted: ${DELETED}"
  echo "==============================="
  log "Cleanup completed. Files deleted: ${DELETED}"
fi
