<p align="center">
  <img alt="PowerShell" src="https://img.shields.io/badge/PowerShell-5.0+-blue?logo=powershell&logoColor=white" />
  <img alt="Platform" src="https://img.shields.io/badge/Platform-Windows-lightgrey?logo=windows&logoColor=blue" />
  <img alt="License: Unlicense" src="https://img.shields.io/badge/license-Unlicense-lightgrey.svg?logo=openaccess&logoColor=blue" />
  <img alt="Version" src="https://img.shields.io/badge/version-1.2.0-blueviolet?logo=semantic-release" />
  <img alt="Status" src="https://img.shields.io/badge/status-Stable-brightgreen?logo=checkmarx" />
</p>

# PowerShell Script Template

- [Overview](#overview)
- [Logging](#logging)
  - [Examples](#examples)
  - [Log File](#log-file)
  - [Log Rotation](#log-rotation)
  - [Log Levels](#log-levels)
- [Error Handling](#error-handling)
- [Scheduled Task Considerations](#scheduled-task-considerations)
- [Extending the Script](#extending-the-script)
- [License](#license)

## Overview
This template provides a solid starting point for custom PowerShell scripts, allowing you to focus immediately on your core logic. It handles logging, log file rotation, error handling, and environment setup, whether the script runs manually or via Scheduled Task.

Features include:
- Automatic log file creation with timestamped filenames
- Log rotation for files older than a configurable number of days (default: 7)
- Multi-level logging with color-coded console output
- Execution time tracking and clean exit codes
- Module import with error detection and install hints


## Logging
### Examples
Use the `Write-Log` function like this:

```powershell
Write-Log "Removed $user from $group"
Write-Log "Removed $user from $group" -Level "INFO"
Write-Log -Message "$user was not in $group" -Level "WARN"
Write-Log "Failed to remove $user: $_" -Level "ERROR"
Write-Log "This is a debug message" -Level "DEBUG"
Write-Log "Notice: special event happened" -Level "NOTICE"
```

### Log File
Logs are saved to a `logs` subdirectory within the script's root path. The log file is timestamped to avoid overwriting previous runs.

The suffix `-YYYYMMDD-T-HHMMSS.log` is appended automatically to the value of the `$LogFileNamePrefix` variable. For example, with `$LogFileNamePrefix = "bootstrap-logs"`:
```
C:\
└── Scripts\
    ├── bootstrap.ps1
    └── logs\
        └── bootstrap-logs-YYYYMMDD-T-HHMMSS.log
        └── bootstrap-logs-YYYYMMDD-T-HHMMSS.log
        └── bootstrap-logs-YYYYMMDD-T-HHMMSS.log
```
### Log Rotation
Log files older than `$LogFileRetentionDays` (default 7) are automatically deleted at the end of each run. Only files matching the $LogFileNamePrefix pattern are removed to avoid interfering with unrelated logs.

### Log Levels
Supported levels and their usage:
| Level  | Description                       |
|--------|-----------------------------------|
| DEBUG  | Detailed debug infromation        |
| INFO   | General informtion   `defualt `   |
| NOTICE | Important but non-critical events |
| WARN   | Warning condidtions               |
| ERROR  | Errors and exceptions             |
| FATAL  | Critical failure causing exit     |

All log entries are:
- Printed to the console (filtered by `$ConsoleLogLevel`) and color-coded
- Appended to the active log file with timestap
The console output respects the `$ConsoleLogLevel` variable. For example, setting `$ConsoleLogLevel = "WARN"` will show only warnings, errors, and fatal messages in the console, but all logs are still written to the file.

## Error Handling
Wrap your main logic in a try block. Use `throw` to signal errors, which the script logs and exits cleanly:
```powershell
try {
    Remove-ADGroupMember -Identity $group -Users $user -ErrorAction Stop
}
catch {
    throw "Failed to remove $user with error: $_"
}
```

## Scheduled Task Considerations
This script is designed to work well with Scheduled Tasks:
- Uses `$PSScriptRoot` for relative paths
- Sets the current directory to script root for consistent file operations
- Provides console and file logging for runtime visibility and post-run analysis

## Extending the Script
- Add your main automation logic in the Main Script Logic section.
- Add reusable functions in the Custom Functions section.
- Add or remove modules in the Import-Modules function as needed.

## License
This project is released into the public domain under the Unlicense.
