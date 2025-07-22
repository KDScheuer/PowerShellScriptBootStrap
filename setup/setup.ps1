$repoUrl = "https://github.com/kdscheuer/PowerShellScriptBootStrap.git"
$repoName = "PowerShellScriptBootStrap"
$localPath = "$env:USERPROFILE\$repoName"
$snippetSource = "$localPath\setup\powershell.json"
$snippetDest = "$env:APPDATA\Code\User\snippets\powershell.json"

# Clone or update the repo
if (!(Test-Path $localPath)) {
    git clone $repoUrl $localPath
} else {
    Write-Host "Repo already exists. Pulling latest changes..."
    Set-Location $localPath
    git pull
}

# Install VS Code snippet
if (Test-Path $snippetSource) {
    Write-Host "Copying PowerShell snippets to VS Code..."
    Copy-Item $snippetSource $snippetDest -Force
    Write-Host "✅ Snippets installed to: $snippetDest"
} else {
    Write-Warning "🚫 Snippet file not found: $snippetSource"
}
