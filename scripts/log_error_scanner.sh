#!/usr/bin/env bash
# ==============================================================================
# Script Name: log_error_scanner.sh
# Description: Scans systemd journal and auth logs for critical errors & SSH fails
# Author:      Sakthivel
# ==============================================================================

set -euo pipefail

HOURS_BACK="${1:-24}"

echo "=================================================================="
echo " SYSTEM LOG & SECURITY ERROR SCAN (Last ${HOURS_BACK} Hours)"
echo " Host: $(hostname) \vert{} Time:$(date)"
echo "=================================================================="

echo -e "\n[1] Critical & Error Entries in Systemd Journal:"
if command -v journalctl >/dev/null 2>&1; then
    journalctl -p err..emerg --since "${HOURS_BACK} hours ago" --no-pager | tail -n 25 || echo "No critical journal entries found."
else
    echo "journalctl not available; checking /var/log/syslog or /var/log/messages..."
    grep -iE "error|critical|fail" /var/log/messages /var/log/syslog 2>/dev/null | tail -n 25 || true
fi

echo -e "\n[2] Top Failed SSH Login Attempts (Brute-Force Check):"
AUTH_LOG="/var/log/secure"
[[ -f /var/log/auth.log ]] && AUTH_LOG="/var/log/auth.log"

if [[ -r "$AUTH_LOG" ]]; then
    grep "Failed password" "$AUTH_LOG" \vert{} awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | head -n 10 || echo "No failed SSH attempts logged."
else
    echo "Run with sudo/root privileges to inspect $AUTH_LOG."
fi

echo -e "\n[3] Out-Of-Memory (OOM) Killer Events:"
dmesg -T 2>/dev/null | grep -i "killed process" | tail -n 10 || echo "No OOM killer events detected."
