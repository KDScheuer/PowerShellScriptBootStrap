$repoUrl = "https://github.com/kdscheuer/PowerShellScriptBootStrap.git"
$repoName = "PowerShellScriptBootStrap"
$localPath = "$env:USERPROFILE\$repoName"
$snippetSource = "$localPath\setup\powershell.json"
$snippetDest = "$env:APPDATA\Code\User\snippets\powershell.json"

# Clone or update the repo
try {
    if (!(Test-Path $localPath)) {
        Write-Host "Temporarily Cloning Repo to $localPath" -ForegroundColor Green
        git clone $repoUrl $localPath | Out-Null
    } else {
        Write-Host "Repo already exists. Pulling latest changes..." -ForegroundColor Green
        Set-Location $localPath
        git pull | Out-Null
    }   
}
catch {
    Write-Warning "Failed to Clone repo with error: $_"
}

# Install VS Code snippet
try {
    if (Test-Path $snippetSource) {
        Write-Host "Copying PowerShell snippets to VS Code..."
        Copy-Item $snippetSource $snippetDest -Force | Out-Null
        Write-Host "✅ Snippets installed to: $snippetDest" -ForegroundColor Green
    } else {
        Write-Warning "🚫 Snippet file not found: $snippetSource"
    }
}
catch {
    Write-Warning "Error Copying files from $snippetSource to $snippetDest"
}
finally {
    Set-Location $env:USERPROFILE
    Remove-Item -Recurse -Force $localPath | Out-Null
    Write-Host "🧹 Deleted temporary repo at: $localPath" -ForegroundColor Green
}
