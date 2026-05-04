#!/bin/bash
# =============================================================================
# system_health.sh — System health report with threshold alerting
# Author: Nerea Arce | github.com/arcenerea
# =============================================================================

# --- Thresholds ---
CPU_THRESHOLD=80
RAM_THRESHOLD=85
DISK_THRESHOLD=90

LOG_FILE="/var/log/system_health.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

alert() {
  echo "⚠️  ALERT: $1"
  log "ALERT: $1"
}

# --- CPU ---
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'.' -f1)

echo "==============================="
echo "   System Health Report"
echo "   $(date '+%Y-%m-%d %H:%M:%S')"
echo "==============================="
echo ""
echo "--- CPU ---"
echo "Usage: ${CPU_USAGE}%"
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
  alert "CPU usage is ${CPU_USAGE}% (threshold: ${CPU_THRESHOLD}%)"
fi

# --- RAM ---
RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
RAM_USED=$(free -m | awk '/Mem:/ {print $3}')
RAM_USAGE=$(awk "BEGIN {printf \"%d\", ($RAM_USED/$RAM_TOTAL)*100}")

echo ""
echo "--- RAM ---"
echo "Used: ${RAM_USED}MB / ${RAM_TOTAL}MB (${RAM_USAGE}%)"
if [ "$RAM_USAGE" -gt "$RAM_THRESHOLD" ]; then
  alert "RAM usage is ${RAM_USAGE}% (threshold: ${RAM_THRESHOLD}%)"
fi

# --- Disk ---
echo ""
echo "--- Disk ---"
while IFS= read -r LINE; do
  USAGE=$(echo "$LINE" | awk '{print $5}' | tr -d '%')
  MOUNT=$(echo "$LINE" | awk '{print $6}')
  echo "  $LINE"
  if [ "$USAGE" -gt "$DISK_THRESHOLD" ]; then
    alert "Disk ${MOUNT} is at ${USAGE}% (threshold: ${DISK_THRESHOLD}%)"
  fi
done < <(df -h | grep '^/dev/')

# --- Top processes ---
echo ""
echo "--- Top 5 processes by CPU ---"
ps aux --sort=-%cpu | awk 'NR==1 || NR<=6' | awk '{printf "%-10s %-6s %-6s %s\n", $1, $2, $3, $11}'

echo ""
echo "==============================="
log "Health check completed. CPU: ${CPU_USAGE}% | RAM: ${RAM_USAGE}%"
