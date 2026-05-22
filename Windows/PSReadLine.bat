@echo off
setlocal

echo PowerShell PSReadLine Setup

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"& {
    $ErrorActionPreference = 'Stop'

    try {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

        if (-not (Get-PackageProvider NuGet -ErrorAction SilentlyContinue)) {
            Install-PackageProvider NuGet -Force | Out-Null
        }

        Import-Module PowerShellGet -Force

        Install-Module PSReadLine -Repository PSGallery -Scope CurrentUser -Force -Confirm:$false

        Write-Host 'Setup complete.'
    }
    catch {
        Write-Host $_.Exception.Message
        exit 1
    }
}"

pause