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