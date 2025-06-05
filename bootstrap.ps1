<#
.SYNOPSIS
    Powershell Script Template

.DESCRIPTION
    This script is a template to aid in the development of scripts. It includes built in Logging and Log Rotation.

.PARAMETER SomeParameter
    Description of what SomeParameter does defined in the Script Parameters Section.

.PARAMETER SomeOtherParameter
    Description of what SomeOtherParameter does defined in the Script Parameters Section.

.EXAMPLE
    .\bootstrap.ps1 -SomeParameter "something"

.NOTES
    Author: Kristopher Scheuer
    Created: 20250603
    Modified: 20250604
    Version: 1.1.0

#>

# ============================================================
# SECTION: Script Parameters
# ============================================================
param (
    [string]$SomeParameter,
    [string]$SomeOtherParameter
)


# ============================================================
# SECTION: Global Variables
# ============================================================
$LogFilePath = "$PSScriptRoot\logs"
$LogFileNamePrefix = "bootstrap-logs"
$LogFileRetentionDays = 7


# ============================================================
# SECTION: Script Variable Constaints
# ============================================================
$ScriptStartTime = Get-Date
Set-Location -Path $PSScriptRoot
$LogFileName = "$LogFileNamePrefix-$(Get-Date -Format 'yyyyMMdd-T-HHmmss').log"
$LogFilePattern = "$LogFileNamePrefix-*.log"
$LogFile = Join-Path $LogFilePath $LogFileName


# ============================================================
# SECTION: Create Log File
# ============================================================
try {
    if (-not $LogFilePath -or -not $LogFileName -or -not $LogFile) {
        throw "Log path not specified."
    }
    if (-not (Test-Path $LogFilePath)) {
        New-Item -ItemType Directory -Path $LogFilePath | Out-Null
    }   
}
catch {
    throw "Error creating log directory: $_"
}


# ============================================================
# SECTION: Logging Function
# ============================================================
function Write-Log {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [ValidateSet("INFO", "WARN", "ERROR")]
        [string]$Level = "INFO"
    )

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] [$Level] $Message"
    
    switch ($Level) {
        "INFO" { Write-Host $LogEntry }
        "WARN" { Write-Host $LogEntry -ForegroundColor Yellow }
        "ERROR" { Write-Host $LogEntry -ForegroundColor Red }
    }
    
    try {
        Add-Content -Path $LogFile -Value $LogEntry
    }
    catch {
        throw "Error Writing to LogFile: $_"
    }
}


# ============================================================
# SECTION: Log Rotation Function
# ============================================================
function Remove-OldLogs {
    param (
        [int]$RetentionDays = 7
    )
    
    try {
        $OldLogs = Get-ChildItem -Path $LogFilePath -File -Filter $LogFilePattern | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays) }
        if ($OldLogs) {
            $OldLogs | Remove-Item -Force
        }
    }
    catch {
        throw "Failed to rotate log files: $_"
    }
}


# ============================================================
# SECTION: Custom Imports
# ============================================================
    #=======================================
    # Add and Import-Module Commands Here
    #=======================================


# ============================================================
# SECTION: Custom Functions
# ============================================================
    #=======================================
    # Add your Scripts Custom Functions Here
    #=======================================


# ============================================================
# SECTION: Main Script Logic
# ============================================================
try {
    Clear-Host
    #===========================
    # Your Script should go here
    #===========================
}
catch {
    Write-Log -Message "Error: $_" -Level "ERROR"
    exit 1
}
finally {
    $duration = (Get-Date) - $ScriptStartTime
    Write-Log -Message "Script finished. Duration: $($duration.TotalSeconds) seconds."
    Remove-OldLogs -RetentionDays $LogFileRetentionDays
    exit 0
}