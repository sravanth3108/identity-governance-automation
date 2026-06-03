# Architecture — Identity Governance Automation

## Overview
This project automates the identification and reporting of inactive Active Directory user accounts.
Designed to support identity hygiene, reduce attack surface, and eliminate manual audit overhead.

## Execution Flow
```
AD → Query Layer → Filter Engine → Reporting → Logging → Review
```

## Execution Modes

### REPORT ONLY (default)
- Identifies inactive accounts based on LastLogonDate threshold
- Generates audit CSV reports
- No changes made to Active Directory

### ACTION MODE (future extension)
- Intended for automated remediation (e.g., disabling accounts)
- Currently disabled for safety and review compliance

## Design Principles
- Safe by default (report-only mode)
- No destructive actions without explicit opt-in
- Fully auditable execution logs
- Repeatable daily execution (scheduled task compatible)

## Logging Format
```
[YYYY-MM-DD HH:MM:SS] [LEVEL] Message
```
Levels: INFO | WARN | ERROR

## Future Extensions
- SIEM integration (Splunk / Microsoft Sentinel)
- Email + Teams alerting
- Automated remediation workflows
- Azure AD / Entra ID migration path
- GitHub Actions CI pipeline for script validation
