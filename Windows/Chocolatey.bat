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
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
call refreshenv
PowerShell -NoProfile -Command "Set-ExecutionPolicy RemoteSigned -Force"
echo.

set /p confirm="Do you want to install Chocolatey helpers (GUI, cleaner, gsudo)? (y/n): "
if /i "%confirm%"=="y" (
    echo --- Install Chocolatey helpers
    choco upgrade chocolateygui choco-cleaner gsudo -y --no-progress
) else (
    echo Skipping Chocolatey helpers.
)
echo.



:: ----------------------------------------------------------
:: ----------Install system packages-------------------------
:: ----------------------------------------------------------
set /p confirm="Do you want to install system runtime packages (DirectX, VC++ Redist)? (y/n): "
if /i "%confirm%"=="y" (
    echo --- Install system runtimes
    choco upgrade directx vcredist-all -y --no-progress
) else (
    echo Skipping system packages.
)
echo.



:: ----------------------------------------------------------
:: ----------Install multimedia packages---------------------
:: ----------------------------------------------------------
set /p confirm="Do you want to install multimedia and archiving packages (K-Lite, WinRAR)? (y/n): "
if /i "%confirm%"=="y" (
    echo --- Install multimedia and archiving tools
    choco upgrade k-litecodecpackfull winrar -y --no-progress
) else (
    echo Skipping multimedia packages.
)
echo.



:: ----------------------------------------------------------
:: ----------Install developer packages----------------------
:: ----------------------------------------------------------
set /p confirm="Do you want to install developer packages? (y/n): "
if /i "%confirm%"=="y" (
    echo --- Install PSReadLine
    PowerShell -NoProfile -Command "Install-Module -Name PSReadLine -Force -Confirm:$false -ErrorAction SilentlyContinue"
    echo.

    set /p subconfirm="Install core dev tools (VSCode, Git, GitHub Desktop, Python, Node.js LTS, .NET SDK)? (y/n): "
    if /i "%subconfirm%"=="y" (
        echo --- Install core dev tools
        choco upgrade vscode git github-desktop python nodejs.lts dotnet-sdk -y --no-progress
    ) else (
        echo Skipping core dev tools.
    )
    echo.

    set /p subconfirm="Install virtualization packages (Docker Desktop, WSL2)? Warning: These are heavy and slow. (y/n): "
    if /i "%subconfirm%"=="y" (
        echo --- Install Docker Desktop
        choco upgrade docker-desktop -y --no-progress

        echo --- Install WSL2 via Windows feature (recommended over choco)
        PowerShell -NoProfile -Command "wsl --install --no-distribution" 2>nul || (
            echo WSL2 install via wsl --install failed, falling back to choco...
            choco upgrade wsl2 -y --no-progress
        )
    ) else (
        echo Skipping virtualization packages.
    )
) else (
    echo Skipping developer packages.
)
echo.



:: ----------------------------------------------------------
:: ----------Upgrade all packages----------------------------
:: ----------------------------------------------------------
echo --- Upgrading all installed Chocolatey packages...
choco upgrade all -y --no-progress
echo.

:: Pause to view result
pause
endlocal
exit /b 0