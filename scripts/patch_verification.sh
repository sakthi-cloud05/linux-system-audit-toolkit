#!/usr/bin/env bash
# ==============================================================================
# Script Name: patch_verification.sh
# Description: Pre/Post monthly maintenance patching validation script
# Author:      Sakthivel
# ==============================================================================

set -euo pipefail

echo "=================================================================="
echo " LINUX PATCH & MAINTENANCE VALIDATION REPORT"
echo "=================================================================="

echo "Hostname       : $(hostname)"
echo "Current Kernel : $(uname -r)"
echo "System Uptime  : $(uptime -p)"

if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    echo "OS Distribution: $PRETTY_NAME"
fi

echo -e "\n--- Checking Pending Security/Package Updates ---"
if command -v dnf >/dev/null 2>&1; then
    dnf check-update --security -q || true
elif command -v yum >/dev/null 2>&1; then
    yum check-update --security -q || true
elif command -v apt-get >/dev/null 2>&1; then
    apt-get -s upgrade | grep -i "^Inst" | head -n 15 || echo "All packages up to date."
fi

echo -e "\n--- Checking Reboot Requirement ---"
if [[ -f /var/run/reboot-required ]]; then
    echo "[ACTION REQUIRED] System reboot is pending to apply kernel/library updates."
elif command -v needs-restarting >/dev/null 2>&1; then
    needs-restarting -r || true
else
    echo "[OK] No pending reboot flags detected."
fi
