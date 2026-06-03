# reports/

This folder stores CSV audit reports generated at runtime.

## Important

- All `.csv` files are **gitignored in production** to prevent accidental exposure of AD account data
- The `InactiveUsers.csv` file in this folder is a **sample output only** for demonstration purposes
- Real reports are generated each time `Find-InactiveADUsers.ps1` runs

## Report Schema

| Column         | Description                          |
|----------------|--------------------------------------|
| Name           | Display name of the AD user          |
| SamAccountName | AD login username                    |
| LastLogonDate  | Timestamp of last successful logon   |
| Enabled        | Whether the account is active        |

## Usage

Reports are intended for review by IT administrators or security teams before any remediation action is taken.
This supports the human-in-the-loop governance model.
