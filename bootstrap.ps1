# ============================================================
# SECTION: Script Parameters (CLI Arguments)
# ============================================================
param (
    [string]$SomeParameter,
    [string]$SomeOtherParameter
)

# ============================================================
# SECTION: Custom Imports
# ============================================================
    #=======================================
    # Add and Import-Module Commands Here
    #=======================================


# ============================================================
# SECTION: Global Variables (Changable Values)
# ============================================================
$LogFilePath = "$PSScriptRoot\logs"
$LogFileNamePrefix = "bootstrap-logs"
$LogFileRetentionDays = 7


# ============================================================
# SECTION: Global Variables (Vars that shouldn't be changed) 
# ============================================================
$ScriptStartTime = Get-Date
Set-Location -Path $PSScriptRoot
$LogFileName = "$LogFileNamePrefix-$(Get-Date -Format 'yyyyMMdd-T-HHmmss').log"
$LogFilePattern = "$LogFileNamePrefix-*.log"
$LogFile = Join-Path $LogFilePath $LogFileName


# ============================================================
# SECTION: Log File Management
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
    Write-Log -Message "Script Start"
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
    Write-Log -Message "Script Finished. Duration: $($duration.TotalSeconds) seconds."
    Remove-OldLogs -RetentionDays $LogFileRetentionDays
    exit 0
}