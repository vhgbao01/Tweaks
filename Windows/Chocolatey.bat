@echo off

:: Ensure admin privileges
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select "Run as administrator".
        pause & exit 1
    )
    exit 0
)

:: Initialize environment
setlocal EnableExtensions DisableDelayedExpansion



:: ----------------------------------------------------------
:: ----------Install Chocolatey------------------------------
:: ----------------------------------------------------------
echo --- Install Chocolatey
PowerShell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
PowerShell refreshenv
PowerShell Set-ExecutionPolicy RemoteSigned



:: ----------------------------------------------------------
:: ----------Install essential packages----------------------
:: ----------------------------------------------------------
echo --- Install choco-cleaner
choco upgrade choco-cleaner -y

echo --- Install gsudo
choco upgrade gsudo -y

echo --- Install directx
choco upgrade directx -y

echo --- Install Microsoft Visual C++ Runtime
choco upgrade vcredist-all -y

echo --- Install winrar
choco upgrade winrar -y

echo --- Install 7zip
choco upgrade 7zip -y

echo --- Install k-lite codec pack full
choco upgrade k-litecodecpackfull -y



:: ----------------------------------------------------------
:: ----------Install developer packages----------------------
:: ----------------------------------------------------------
echo --- Install PSReadline
Powershell Install-Module -Name PSReadLine -Force -Confirm:$False

echo --- Install python
choco upgrade python -y

echo --- Install nodejs
choco upgrade nodejs-lts -y

echo --- Install dotnet-sdk
choco upgrade dotnet-sdk -y

echo --- Install vscode
choco upgrade vscode -y

echo --- Install git and github
choco upgrade git -y
choco upgrade github-desktop -y

echo --- Install Windows Subsystem for Linux 2
choco upgrade wsl2 -y

echo --- Install docker-desktop
choco upgrade docker-desktop -y

echo --- Install Visual Studio 2022 Build Tools
choco upgrade visualstudio2022community --package-parameters "--add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended" -y --timeout 0



:: Pause the script to view the final state
pause
:: Restore previous environment settings
endlocal
:: Exit the script successfully
exit /b 0