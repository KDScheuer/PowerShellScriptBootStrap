# ==========   Imports   ==========
#Requires -modules ActiveDirectory


# ==========   Variables   ==========
$LogFilePath = "$PSScriptRoot\logs"
$LogFile = Join-Path $LogFilePath "bootstrap-logs-$(Get-Date -Format 'yyyyMMdd-T-HHmmss').log"
$ScriptStartTime = Get-Date


# ==========   Logging   ==========
if (-not (Test-Path $LogFilePath)) { New-Item -ItemType Directory -Path $LogFilePath | Out-Null }   

function Write-Log {
    param (
        [string]$Message = "-", 
        [ValidateSet("INFO", "NOTICE", "WARN", "ERROR")] [string]$Level = "INFO"
    )
    $Colors = @{INFO="White"; NOTICE="Cyan"; WARN="Yellow"; ERROR="RED"}
    $LogEntry = "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")] [$Level] $Message"
    Write-Host $LogEntry -ForegroundColor $Colors[$Level]
    Add-Content -Path $LogFile -Value $LogEntry
}


Clear-Host
Write-Log -Message "Script Start: $ScriptStartTime"
# ==========   Script Start   ==========


# ==========   Script End   ==========
Write-Log -Message "Script Finished. Duration: $(((Get-Date) - $ScriptStartTime).TotalSeconds) seconds."