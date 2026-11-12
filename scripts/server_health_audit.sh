#!/usr/bin/env bash
# ==============================================================================
# Script Name: server_health_audit.sh
# Description: Automated Linux server health & resource consumption audit
# Author:      Sakthivel
# ==============================================================================

set -euo pipefail

REPORT_DIR="/tmp/server_audits"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="${REPORT_DIR}/health_audit_${HOSTNAME}_${TIMESTAMP}.log"

mkdir -p "$REPORT_DIR"

log_section() {
    echo -e "\n=================================================================="
    echo " $1"
    echo "=================================================================="
}

{
    echo "SERVER HEALTH AUDIT REPORT"
    echo "Generated At : $(date)"
    echo "Hostname     : $(hostname -f 2>/dev/null || hostname)"
    echo "OS / Kernel  : $(uname -srm)"
    echo "Uptime       : $(uptime -p)"

    log_section "1. CPU LOAD & TOP 5 CPU-CONSUMING PROCESSES"
    uptime
    echo ""
    ps -eo pid,ppid,user,%cpu,%mem,comm --sort=-%cpu | head -n 6

    log_section "2. MEMORY & SWAP UTILIZATION"
    free -h
    echo ""
    ps -eo pid,ppid,user,%mem,%cpu,comm --sort=-%mem | head -n 6

    log_section "3. FILESYSTEM & DISK SPACE USAGE (>80% WARNING)"
    df -hT | grep -vE '^tmpfs|^devtmpfs'
    echo ""
    df -h | awk '0+$5 >= 80 {print "[WARNING] High Disk Usage on " $6 ": " $5}'

    log_section "4. SYSTEMD FAILED UNITS & CRITICAL SERVICES"
    systemctl --failed --no-pager || echo "No failed systemd units detected."

    log_section "5. ACTIVE LISTENING NETWORK PORTS"
    ss -tulnp | head -n 15

} | tee "$REPORT_FILE"

echo -e "\n[SUCCESS] Audit complete. Report saved to: $REPORT_FILE"
