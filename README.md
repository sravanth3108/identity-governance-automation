# AD Inactive Contractor Account Audit

## Overview

This project automates the identification of inactive contractor accounts in Active Directory.

Organizations often rely on manual reviews to identify accounts that should be disabled after a contractor leaves or becomes inactive. Manual processes can be time-consuming and may lead to stale accounts remaining active longer than intended.

This PowerShell-based solution performs a scheduled audit of contractor accounts, identifies users who have not logged in within a configurable period, and generates a report for review by IT administrators.

## Features

* Active Directory user enumeration
* Inactive account detection based on LastLogonDate
* Configurable inactivity threshold
* CSV report generation
* Logging and audit trail
* Scheduled execution support
* Error handling and validation

## Problem Statement

Inactive accounts represent both an operational and security challenge.

Common risks include:

* Orphaned contractor accounts
* Excessive privileges remaining assigned
* Increased attack surface
* Manual audit overhead

The goal of this project is to improve identity hygiene by providing consistent and repeatable account auditing.

## Sample Workflow

1. Script runs daily via Task Scheduler.
2. Active Directory contractor accounts are queried.
3. Accounts inactive beyond the configured threshold are identified.
4. Results are exported to a report.
5. IT administrators review findings and determine appropriate remediation actions.

## Technologies Used

* PowerShell
* Active Directory Module
* Windows Task Scheduler
* CSV Reporting

## Example Output

| Name       | SamAccountName | LastLogonDate | Status |
| ---------- | -------------- | ------------- | ------ |
| John Smith | jsmith         | 2026-03-01    | Review |
| Jane Doe   | jdoe           | 2026-02-15    | Review |

## Future Enhancements

* Email notifications
* Microsoft Teams alerts
* ServiceNow ticket creation
* Azure AD / Entra ID integration
* Automated remediation workflows
* Dashboard reporting

## Security Considerations

This project is intended to support account review processes.

No accounts are automatically disabled by default. Human review and approval should be incorporated before performing access changes in production environments.

## Lessons Learned

Building automation for identity management reinforced a simple principle:

If access is granted automatically, it should also be reviewed automatically.

Many of the same concepts used for Active Directory account governance apply to cloud IAM, privileged access management, and Zero Trust security models.

## Author

Sravanth Reddy

IT Operations | Automation | Cloud & DevOps Learning Journey
