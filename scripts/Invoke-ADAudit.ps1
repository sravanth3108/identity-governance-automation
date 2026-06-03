$ScriptPath = Join-Path $PSScriptRoot "Find-InactiveADUsers.ps1"

Write-Host "Starting Identity Governance Automation Pipeline..."

powershell.exe -ExecutionPolicy Bypass -File $ScriptPath `
    -InactiveDays 30 `
    -DryRun

Write-Host "Pipeline execution completed."
