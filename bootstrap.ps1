# ============================================================
# SECTION: Custom Imports
# ============================================================
function Import-Modules {
    $requiredModules = @(
        @{ Name = "ActiveDirectory"; InstallHint = "Install-WindowsFeature RSAT-AD-Powershell"},
        @{ Name = "VMware.PowerCLI"; InstallHint = "Install-Module VMware.PowerCLI"}
    )

    foreach ($module in $requiredModules) {
        try {
            Import-Module $module.Name -ErrorAction Stop
            Write-Log "Imported module: $($module.Name)" -Level "DEBUG"
        }
        catch {
            Write-Log "FATAL ERROR: Required module $($module.Name) is not installed or failed to load." -Level "FATAL"
            Write-Log "Hint: $($module.InstallHint)" -Level "FATAL"
            throw "Missing required module: $($module.Name)"
        }
    }
}


# ============================================================
# SECTION: Global Variables (Changable Values)
# ============================================================
$LogFilePath = "$PSScriptRoot\logs"
$LogFileNamePrefix = "bootstrap-logs"
$LogFileRetentionDays = 7
$ConsoleLogLevel = "DEBUG"


# ============================================================
# SECTION: Global Variables (Vars that shouldn't be changed) 
# ============================================================
$ScriptStartTime = Get-Date
Set-Location -Path $PSScriptRoot
$LogFileName = "$LogFileNamePrefix-$(Get-Date -Format 'yyyyMMdd-T-HHmmss').log"
$LogFilePattern = "$LogFileNamePrefix-*.log"
$LogFile = Join-Path $LogFilePath $LogFileName
$ScriptSucceeded = $true


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
        [ValidateSet("DEBUG", "INFO", "NOTICE", "WARN", "ERROR", "FATAL")]
        [string]$Level = "INFO"
    )

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] [$Level] $Message"
    

    $logLevels = @("DEBUG", "INFO", "NOTICE", "WARN", "ERROR", "FATAL")
    $currentLevelIndex = $logLevels.IndexOf($Level)
    $thresholdIndex = $logLevels.IndexOf($ConsoleLogLevel)
    # Write to screen only if level meets or exceeds threshold
    if ($currentLevelIndex -ge $thresholdIndex) {
        switch ($Level) {
            "DEBUG"  { Write-Host $LogEntry -ForegroundColor DarkGray }
            "INFO"   { Write-Host $LogEntry -ForegroundColor White }
            "NOTICE" { Write-Host $LogEntry -ForegroundColor Cyan }
            "WARN"   { Write-Host $LogEntry -ForegroundColor Yellow }
            "ERROR"  { Write-Host $LogEntry -ForegroundColor DarkRed }
            "FATAL"  { Write-Host $LogEntry -ForegroundColor Red }
        }
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
    Write-Log -Message "Script Start: $ScriptStartTime" -Level "INFO"
    Write-Log "Running on computer: $env:COMPUTERNAME as user: $env:USERNAME" -Level "DEBUG"
    Write-Log "PowerShell version: $($PSVersionTable.PSVersion)" -Level "DEBUG"
    Write-Log "Script path: $PSScriptRoot" -Level "DEBUG"
    Import-Modules

    #===========================
    # Your Script should go here
    #===========================
}
catch {
    Write-Log -Message "Error: $_" -Level "FATAL"
    $ScriptSucceeded = $false
}
finally {
    $duration = (Get-Date) - $ScriptStartTime
    Write-Log -Message "Script Finished. Duration: $($duration.TotalSeconds) seconds."
    Remove-OldLogs -RetentionDays $LogFileRetentionDays
    if (-not $ScriptSucceeded) {
        exit(1)
    }
    exit 0
}