# 🛡️ Linux System Automation & Audit Toolkit

An enterprise-grade Bash automation suite built for **Linux Systems Administrators** and **DevOps Engineers** to standardize server health checks, diagnose resource bottlenecks, audit security logs, and validate monthly infrastructure patching across RHEL, CentOS, and Ubuntu environments.

---

## 🎯 Why This Toolkit Exists
In production Linux environments, manual troubleshooting across multiple nodes slows down incident response and post-patch verification. This toolkit automates core diagnostic workflows—combining process inspection (`ps`, `uptime`), storage thresholds (`df`), systemd unit checks (`systemctl`), and log analysis (`journalctl`, `dmesg`)—into repeatable, zero-dependency shell scripts.

---

## 📂 Repository Structure

```text
linux-system-audit-toolkit/
├── scripts/
│   ├── server_health_audit.sh   # Comprehensive CPU, RAM, Disk, Service & Port audit
│   ├── log_error_scanner.sh     # Scans journald, SSH auth logs & OOM killer events
│   └── patch_verification.sh    # Pre/post patching kernel, package & reboot validator
├── screenshots/
│   └── sample-audit-report.png  # Sample terminal execution output
└── README.md

