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


:: ----------------------------------------------------------
:: ----------Install essential packages----------------------
:: ----------------------------------------------------------
echo --- Install choco-cleaner
choco install choco-cleaner -y

echo --- Install gsudo
choco install gsudo -y

echo --- Install 7zip
choco install 7zip -y

echo --- Install k-lite codec pack full
choco install k-litecodecpackfull -y


:: ----------------------------------------------------------
:: ----------Install developer packages----------------------
:: ----------------------------------------------------------
echo --- Install PSReadline
Powershell Install-Module -Name PSReadLine -force

echo --- Install python
choco install python -y

echo --- Install nodejs
choco install nodejs-lts -y

echo --- Install dotnet-sdk
choco install dotnet-sdk -y

echo --- Install golang
choco install golang -y

echo --- Install github
choco install github-desktop -y

echo --- Install vscode
choco install vscode -y

echo --- Install docker-desktop
choco install docker-desktop -y

echo --- Install mobaxterm
choco install mobaxterm -y

:: Pause the script to view the final state
pause
:: Restore previous environment settings
endlocal
:: Exit the script successfully
exit /b 0