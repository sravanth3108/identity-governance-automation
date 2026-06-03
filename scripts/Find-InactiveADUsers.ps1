<#
.SYNOPSIS
    Identifies inactive Active Directory user accounts and generates an audit report.

.DESCRIPTION
    Queries Active Directory for enabled user accounts that have not logged in
    within the specified threshold. Outputs a CSV report and structured log.
    Runs in REPORT ONLY mode by default — no changes are made to Active Directory.

.PARAMETER InactiveDays
    Number of days since last logon to consider an account inactive. Default: 30.

.PARAMETER SearchBase
    The Active Directory OU to search. Default: OU=Users,DC=example,DC=com.

.PARAMETER OutputPath
    Path to write the CSV audit report. Default: ..\reports\InactiveUsers.csv.

.PARAMETER LogPath
    Path to write the structured execution log. Default: ..\logs\audit.log.

.PARAMETER ConfigPath
    Optional path to a config.json file. Values override defaults if provided.

.PARAMETER DryRun
    When set, runs in REPORT ONLY mode. No changes made to AD. Default: true.

.EXAMPLE
    .\Find-InactiveADUsers.ps1 -InactiveDays 60 -DryRun
    .\Find-InactiveADUsers.ps1 -ConfigPath "..\config\config.json" -DryRun
#>

Import-Module ActiveDirectory -ErrorAction Stop

param (
    [int]$InactiveDays = 30,
    [string]$SearchBase = "OU=Users,DC=example,DC=com",
    [string]$OutputPath = "..\reports\InactiveUsers.csv",
    [string]$LogPath = "..\logs\audit.log",
    [string]$ConfigPath = "",
    [switch]$DryRun = $true
)

# ---------------------------
# Logging Function
# ---------------------------
function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] [$Level] $Message"

    # Ensure log directory exists
    $LogDir = Split-Path -Parent $LogPath
    if ($LogDir -and -not (Test-Path $LogDir)) {
        New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
    }

    Add-Content -Path $LogPath -Value $LogEntry
    Write-Host $LogEntry
}

# ---------------------------
# Load Config (if provided)
# ---------------------------
if ($ConfigPath -and (Test-Path $ConfigPath)) {
    try {
        $Config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json
        if ($Config.InactiveDaysThreshold) { $InactiveDays = $Config.InactiveDaysThreshold }
        if ($Config.SearchBase)            { $SearchBase   = $Config.SearchBase }
        if ($Config.ReportPath)            { $OutputPath   = $Config.ReportPath }
        if ($Config.LogPath)               { $LogPath      = $Config.LogPath }
        Write-Log "Configuration loaded from $ConfigPath"
    }
    catch {
        Write-Log "WARNING: Could not parse config file. Using defaults. Error: $_" "WARN"
    }
}

# ---------------------------
# Input Validation
# ---------------------------
if ($InactiveDays -le 0) {
    Write-Log "ERROR: InactiveDays must be a positive integer. Received: $InactiveDays" "ERROR"
    exit 1
}

try {
    $null = Get-ADOrganizationalUnit -Identity $SearchBase -ErrorAction Stop
}
catch {
    Write-Log "ERROR: SearchBase OU not found or inaccessible: '$SearchBase'" "ERROR"
    Write-Log "Verify the OU path and your AD permissions before retrying." "ERROR"
    exit 1
}

# Ensure report output directory exists
$ReportDir = Split-Path -Parent $OutputPath
if ($ReportDir -and -not (Test-Path $ReportDir)) {
    New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
}

# ---------------------------
# Start Execution
# ---------------------------
Write-Log "Identity Governance Audit started"
Write-Log "Mode: $(if ($DryRun) {'REPORT ONLY'} else {'ACTION MODE'})"
Write-Log "SearchBase: $SearchBase"
Write-Log "Inactive threshold: $InactiveDays days"

$CutoffDate = (Get-Date).AddDays(-$InactiveDays)
Write-Log "Cutoff date: $CutoffDate"

try {
    $Users = Get-ADUser -SearchBase $SearchBase -Filter * `
        -Properties LastLogonDate, Enabled, SamAccountName, Description |
        Where-Object {
            $_.Enabled -eq $true -and
            $_.LastLogonDate -ne $null -and
            $_.LastLogonDate -lt $CutoffDate
        } |
        Select-Object Name, SamAccountName, LastLogonDate, Enabled, Description

    Write-Log "Inactive accounts identified: $($Users.Count)"

    if ($Users.Count -eq 0) {
        Write-Log "No inactive accounts found. No report generated." "INFO"
        exit 0
    }

    # ---------------------------
    # Report Generation
    # ---------------------------
    $Users | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Log "Report written to $OutputPath"

    # ---------------------------
    # Action Mode (future remediation)
    # ---------------------------
    if (-not $DryRun) {
        Write-Log "ACTION MODE active — processing $($Users.Count) accounts" "WARN"
        foreach ($user in $Users) {
            # Placeholder: add Disable-ADAccount here when ready for remediation
            Write-Log "Flagged for remediation: $($user.SamAccountName) | Last logon: $($user.LastLogonDate)" "WARN"
        }
    }

    Write-Log "Audit completed successfully"
}
catch {
    Write-Log "ERROR: $_" "ERROR"
    exit 1
}
