# PowerShell Script Template

## Overview

This is a PowerShell script template designed to serve as a robust starting point for developing automated tasks. It includes built-in logging, log rotation, script duration tracking, and parameter documentation.


## Logging

Logs are saved to a `logs` subdirectory within the script's root path. The log file is timestamped to avoid overwriting previous runs:

```
logs/bootstrap-logs-YYYYMMDD-T-HHMMSS.log
```

### Log Levels

* `INFO` - General information
* `WARN` - Warnings
* `ERROR` - Critical issues and exceptions

Log entries are both printed to the console and appended to the log file.

## Log Rotation

Log files older than 7 days are automatically deleted at the end of each run. You can modify the retention period by adjusting the `$LogFileRetentionDays` variable.

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
Version: 1.0.0

---

Feel free to fork or clone this template to jumpstart your own automation projects.
