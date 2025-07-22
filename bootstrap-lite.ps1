<#
.SYNOPSIS
    One sentence describing this scripts purpose.
.DESCRIPTION
    More detailed describing scripts purpose.
.EXAMPLE
    .\bootstrap.ps1
    Add more .EXAMPLE statements if this script can be executed in more then one way.
.INPUTS
    Any Inputs required for this script. 
.OUTPUTS
    Log File to .\logs\bootstrap-logs-yyyyMMdd-T-HHmmss.log
.NOTES
    Execution: [Ad-Hoc | Scheduled Task]
    Compatibility: PowerShell 5.1, and higher
    Version 1.0.0
        # Versioning Guide:
        # - Major Version (X.0.0): Significant changes to the logic, architecture.
        # - Minor Version (1.X.0): Adding New Features or Improvements.
        # - Patch Version (1.0.X): Bug Fixes and Logging Changes.
    Change Log:
    | Name               | Date       | Version    | Change                                                                                                       |
    |--------------------|------------|------------|--------------------------------------------------------------------------------------------------------------|
    | FirstName LastName | YYYY-MM-DD | 1.0.0      | Initial Commit                                                                                               |
#>

# ==========   Imports   ==========
# Requires -modules ActiveDirectory


# ==========   Variables   ==========
$LogFilePath = "$PSScriptRoot\logs"
$LogFile = Join-Path $LogFilePath "bootstrap-logs-$(Get-Date -Format 'yyyyMMdd-T-HHmmss').log"
$ScriptStartTime = Get-Date


# ==========   Logging   ==========
if (-not (Test-Path $LogFilePath)) { New-Item -ItemType Directory -Path $LogFilePath | Out-Null }   

function Write-Log {
    param (
        [string]$Message = "-", 
        [ValidateSet("DEBUG", "INFO", "NOTICE", "WARN", "ERROR", "FATAL")] [string]$Level = "INFO"
    )
    $Colors = @{DEBUG="DarkGray"; INFO="White"; NOTICE="Cyan"; WARN="Yellow"; ERROR="DARKRED"; FATAL="RED"}
    $LogEntry = "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")] [$Level] $Message"
    Write-Host $LogEntry -ForegroundColor $Colors[$Level]
    Add-Content -Path $LogFile -Value $LogEntry
}


# ==========   Script Start   ==========
Clear-Host
Write-Log -Message "Script Start: $ScriptStartTime"

# ==========   Your Code Here   ==========

Write-Log -Message "Script Finished. Duration: $(((Get-Date) - $ScriptStartTime).TotalSeconds) seconds."
# ==========   Script End   ==========