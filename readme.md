<p align="center">
  <img alt="PowerShell" src="https://img.shields.io/badge/PowerShell-5.0+-blue?logo=powershell&logoColor=white" />
  <img alt="Platform" src="https://img.shields.io/badge/Platform-Windows-lightgrey?logo=windows&logoColor=blue" />
  <img alt="License: Unlicense" src="https://img.shields.io/badge/license-Unlicense-lightgrey.svg?logo=openaccess&logoColor=blue" />
  <img alt="Version" src="https://img.shields.io/badge/version-1.1.0-blueviolet?logo=semantic-release" />
  <img alt="Status" src="https://img.shields.io/badge/status-Stable-brightgreen?logo=checkmarx" />
</p>

# PowerShell Script Template

## Overview
I created this template as a starting point for custom scripts. By templatitizing general script functions this template allows you to imediatly focus on the core logic, knowing that once created a scheduled task or manually ran that all logging and file rotation will be taken care of. 
This script automates
- Log File Creation
- Log File Rotation
- Logging with different levels `["INFO", "WARN", "ERROR"]`
- Execution Time Tracking
- Failure handling easily (just add a `throw "X"` and the script will log the encounted error and exit gracefully)


## Logging
### Examples
Below are example invocations of the `Write-Log` function. Note in this example that the `-Message` is optional and no `-Level` needs to be passed if the log is `INFO`.
```powershell
Write-Log "Removed $user from $group"
Write-Log "Removed $user from $group" -Level "INFO"
Write-Log -Message "$user was not in $group" -Level "WARN"
Write-Log "Failed to remove $user: $_" -Level "ERROR"
```

### Log File
Logs are saved to a `logs` subdirectory within the script's root path. The log file is timestamped to avoid overwriting previous runs.
- The `-YYYYMMDD-T-HHMMSS.log` is appeneded automatically to the value of the `$LogFileNamePrefix` variable. In the below instnace `$LogFileNamePrefix = bootstrap-logs`
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

Log files older than `$LogFileRetentionDays` days are automatically deleted at the end of each run. The default value for this is 7. Log rotations will look for files that begin with the `$LogFileNamePrefix` to avoid deleting logs from other scripts that may happen to also be in the `/logs` directory.

### Log Levels
By default when calling `Write-Log` the `INFO` level is applied. You can modify the level with: `Write-Log "Unexpected value" -Level "ERROR"`.
- Log entries are both printed to the console and appended to the log file for ease of development. 
* `INFO` - General information
* `WARN` - Warnings
* `ERROR` - Critical issues and exceptions

## Error Handling
By placing your code inside the `try` block you are able to exit the program with logging of the encounted error by using `throw`. 
The below example would log the message in the `throw` statement and exit.
```powershell
......
    try {
        Remove-ADGroupMember -Identity $group -Users $user -ErrorAction Stop
    }
    catch {
        throw "Failed to remove $user with: $_"
    }
......
```

## Scheduled Task Considerations

This script is optimized to run reliably as a Scheduled Task:

* Uses `$PSScriptRoot` to ensure paths are relative to the script's location
* Changes working directory to script root using `Set-Location -Path $PSScriptRoot`
* Console and file logging provide runtime feedback and troubleshooting information

## Extending the Script

To customize the script, add your own logic under the `Main Script Logic` section. Define reusable code under `Custom Functions`.

## Author

**Kristopher Scheuer**
Created: June 3, 2025
Version: 1.1.0

---

Feel free to fork or clone this template to jumpstart your own automation projects.








# PowerShell Script Template
## Overview
I created this template as a starting point for custom scripts. By templatizing general script functions, this template allows you to immediately focus on the core logic—knowing that once created, whether run manually or via Scheduled Task, all logging and file rotation will be taken care of.

This script automates:
- Log File Creation
- Log File Rotation
- Logging with different levels: `["INFO", "WARN", "ERROR"]`
- Execution Time Tracking
- Easy failure handling (just add a `throw "X"` and the script will log the encountered error and exit gracefully)

## Logging
### Examples
Below are example invocations of the `Write-Log` function. Note that in this example, the `-Message` is optional and no `-Level` needs to be passed if the log level is `INFO`.

```powershell
Write-Log "Removed $user from $group"
Write-Log "Removed $user from $group" -Level "INFO"
Write-Log -Message "$user was not in $group" -Level "WARN"
Write-Log "Failed to remove $user: $_" -Level "ERROR"
```

### Log File
Logs are saved to a `logs` subdirectory within the script's root path. The log file is timestamped to avoid overwriting previous runs.

The suffix `-YYYYMMDD-T-HHMMSS.log` is appended automatically to the value of the `$LogFileNamePrefix` variable. For example, with `$LogFileNamePrefix = "bootstrap-logs"`:
```bash
C:\
    \Scripts
        bootstrap.ps1
        \logs
            bootstrap-logs-YYYYMMDD-T-HHMMSS.log
            bootstrap-logs-YYYYMMDD-T-HHMMSS.log
            bootstrap-logs-YYYYMMDD-T-HHMMSS.log
```
### Log Rotation
Log files older than `$LogFileRetentionDays` days are automatically deleted at the end of each run. The default is 7 days. Log rotation will only target files that begin with the `$LogFileNamePrefix`, to avoid deleting logs from other scripts that may share the same `logs` directory.

### Log Levels
When calling `Write-Log`, the default level is `INFO`. You can modify it by specifying the level:
```powershell
Write-Log "Unexpected value" -Level "ERROR"
```
All log entries are:
- Printed to the console (with color coding)
- Appended to the active log file

### Log levels:
- INFO – General information
- WARN – Warnings
- ERROR – Critical issues and exceptions

## Error Handling
By placing your code inside a `try` block, you can exit the program with error logging by simply using `throw`. For example:
```powershell
......
try {
    Remove-ADGroupMember -Identity $group -Users $user -ErrorAction Stop
}
catch {
    throw "Failed to remove $user with: $_"
}
......
```
This will log the message inside the `throw` statement and exit cleanly.

## Scheduled Task Considerations
This script is optimized to run reliably as a Scheduled Task:
- Uses `$PSScriptRoot` to ensure all paths are relative to the script's location
- Changes working directory to the script root using `Set-Location -Path $PSScriptRoot`
- Console and file logging provide both runtime feedback and post-run troubleshooting info

## Extending the Script
To customize the script:
- Add your logic under the Main Script Logic section
- Define reusable functionality under Custom Functions

## License
This project is released into the public domain under the Unlicense.
