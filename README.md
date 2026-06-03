# Identity Governance Automation

> PowerShell-based automation for identifying and reporting inactive Active Directory accounts.
> Built to eliminate manual audit overhead and enforce identity hygiene at scale.

---

## Project Structure

```
identity-governance-automation/
├── scripts/
│   ├── Find-InactiveADUsers.ps1   # Core audit script with validation + logging
│   └── Invoke-ADAudit.ps1         # Execution wrapper / pipeline entry point
├── config/
│   └── config.json                # Runtime configuration (wired to script)
├── logs/
│   ├── README.md                  # Log folder documentation
│   └── audit.log                  # Sample output (gitignored in production)
├── reports/
│   ├── README.md                  # Report folder documentation
│   └── InactiveUsers.csv          # Sample output (gitignored in production)
├── docs/
│   └── architecture.md            # System design & execution flow
├── README.md
├── LICENSE
└── .gitignore
```

---

## Quickstart

```powershell
# Run with defaults (report-only, safe)
.\scripts\Invoke-ADAudit.ps1

# Run with config file
powershell.exe -ExecutionPolicy Bypass -File .\scripts\Find-InactiveADUsers.ps1 `
    -ConfigPath ".\config\config.json" -DryRun

# Run with custom threshold
powershell.exe -ExecutionPolicy Bypass -File .\scripts\Find-InactiveADUsers.ps1 `
    -InactiveDays 60 -DryRun
```

---

## Configuration

Edit `config/config.json` — values are loaded automatically by the script at runtime:

```json
{
  "InactiveDaysThreshold": 30,
  "SearchBase": "OU=Users,DC=example,DC=com",
  "ReportPath": "reports/InactiveUsers.csv",
  "LogPath": "logs/audit.log",
  "Mode": "REPORT_ONLY"
}
```

| Parameter              | Default                       | Description                     |
|------------------------|-------------------------------|---------------------------------|
| InactiveDaysThreshold  | 30                            | Days since last logon to flag   |
| SearchBase             | OU=Users,DC=example,DC=com    | AD OU to search                 |
| ReportPath             | reports/InactiveUsers.csv     | Output path for audit report    |
| LogPath                | logs/audit.log                | Output path for execution log   |
| Mode                   | REPORT_ONLY                   | Execution mode                  |

---

## Execution Modes

### REPORT ONLY (default — safe)
- Identifies inactive accounts based on `LastLogonDate` threshold
- Generates structured CSV audit report
- **No changes are made to Active Directory**

### ACTION MODE (future extension)
- Intended for automated remediation (e.g., disabling stale accounts)
- Currently stubbed — requires explicit opt-in by removing `-DryRun`
- Follows a **human-in-the-loop identity governance model**

---

## Input Validation

The script validates inputs before execution:

- `InactiveDays` must be a positive integer — exits with error if invalid
- `SearchBase` OU is verified to exist and be accessible before querying
- Log and report directories are auto-created if missing
- Config file parse errors fall back to defaults gracefully

---

## Logging

All executions produce structured logs:

```
[2026-06-02 08:00:01] [INFO] Identity Governance Audit started
[2026-06-02 08:00:01] [INFO] Mode: REPORT ONLY
[2026-06-02 08:00:02] [INFO] Inactive threshold: 30 days
[2026-06-02 08:00:04] [INFO] Inactive accounts identified: 52
[2026-06-02 08:00:04] [INFO] Report written to ../reports/InactiveUsers.csv
[2026-06-02 08:00:04] [INFO] Audit completed successfully
```

> **Note:** Log files are gitignored in production to prevent sensitive data exposure.

---

## Impact

| Metric                           | Result          |
|----------------------------------|-----------------|
| Stale accounts identified        | 50+             |
| Manual audit time eliminated     | 8+ hours/month  |
| Execution frequency              | Daily           |
| Accounts missed after automation | 0               |

---

## Security Notes

- Sample log and report files are included for demonstration only
- Production `logs/` and `reports/` output is excluded via `.gitignore`
- No credentials or sensitive AD data should ever be committed to this repo
- Always run in `-DryRun` mode first when deploying to a new environment

---

## Roadmap

- [ ] GitHub Actions CI pipeline (PSScriptAnalyzer lint + validation)
- [ ] Email / Microsoft Teams alerting on completion
- [ ] Azure AD / Entra ID support
- [ ] Reusable PowerShell module (.psm1)
- [ ] SIEM integration (Splunk / Microsoft Sentinel)
- [ ] Automated remediation with approval workflow

---

## Tags

`PowerShell` `Active Directory` `Identity Governance` `IAM` `Security Automation` `DevOps` `CloudSecurity`
