@echo off
setlocal EnableExtensions

:: ----------------------------------------------------------
:: Admin check (optional, not required for CurrentUser installs)
:: ----------------------------------------------------------
fltmc >nul 2>&1 || (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ==========================================
echo PowerShell Dev Environment Setup
echo ==========================================

set /p confirm="Proceed with PowerShell setup? (y/n): "
if /i not "%confirm%"=="y" exit /b

:: ----------------------------------------------------------
:: Run PowerShell bootstrap
:: ----------------------------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"& {
    $ErrorActionPreference = 'Stop'

    try {
        # TLS fix for PSGallery
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        # Ensure RemoteSigned for current user
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

        # Ensure NuGet provider
        if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
            Install-PackageProvider -Name NuGet -Force | Out-Null
        }

        # Import PowerShellGet safely
        Import-Module PowerShellGet -Force

        # Install PSReadLine only if missing
        if (-not (Get-Module -ListAvailable PSReadLine)) {
            Install-Module PSReadLine `
                -Repository PSGallery `
                -Scope CurrentUser `
                -Force `
                -Confirm:$false
        }

        Write-Host 'PowerShell environment setup complete.' -ForegroundColor Green
    }
    catch {
        Write-Host 'Setup failed:' -ForegroundColor Red
        Write-Host $_.Exception.Message
        exit 1
    }
}"

echo.
echo Done.
pause
endlocal
exit /b 0