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

set /p confirm="Do you want to install Chocolatey Helper? (y/n): "
if /i "%confirm%"=="y" (
    echo --- Install Chocolatey GUI
    choco upgrade chocolateygui -y

    echo --- Install choco-cleaner
    choco upgrade choco-cleaner -y

    echo --- Install gsudo
    choco upgrade gsudo -y
) else (
    echo Skipping Chocolatey Helper installation.
)



:: ----------------------------------------------------------
:: ----------Install system packages-------------------------
:: ----------------------------------------------------------
set /p confirm="Do you want to install system packages? (y/n): "
if /i "%confirm%"=="y" (
    echo --- Install DirectX End-User Runtime
    choco upgrade directx -y

    echo --- Install Microsoft Visual C++ Runtime
    choco upgrade vcredist-all -y
) else (
    echo Skipping system packages installation.
)



:: ----------------------------------------------------------
:: ----------Install multimedia packages---------------------
:: ----------------------------------------------------------
set /p confirm="Do you want to install multimedia and archiving packages? (y/n): "
if /i "%confirm%"=="y" (
    echo --- Install K-Lite Codec Pack Full
    choco upgrade k-litecodecpackfull -y

    echo --- Install Winrar
    choco upgrade winrar -y

    echo --- Install 7zip
    choco upgrade 7zip -y
) else (
    echo Skipping multimedia and archiving packages installation.
)



:: ----------------------------------------------------------
:: ----------Install developer packages----------------------
:: ----------------------------------------------------------
set /p confirm="Do you want to install developer packages? (y/n): "
if /i "%confirm%"=="y" (
    @REM echo --- Install PSReadline
    @REM Powershell Install-Module -Name PSReadLine -Force -Confirm:$False

    set /p subconfirm="Do you want to core developer packages? (y/n): "
    if /i "%subconfirm%"=="y" (
        echo --- Install Visual Studio Code
        choco upgrade vscode -y

        echo --- Install Git and Github Desktop
        choco upgrade git -y
        choco upgrade github-desktop -y

        echo --- Install Python
        choco upgrade python -y

        echo --- Install Node.js (LTS)
        choco upgrade nodejs-lts -y

        echo --- Install .NET SDK
        choco upgrade dotnet-sdk -y
    ) else (
        echo Skipping core developer packages installation.
    )

    set /p subconfirm="Do you want to install Virtualization packages? (heavy,slow) (Y/n): "
    if /i "%subconfirm%"=="Y" (
        echo --- Install Docker Desktop
        choco upgrade docker-desktop -y

        echo --- Install WSL2
        choco upgrade wsl2 -y
    ) else (
        echo Skipping virtualization packages installation.
    )

    set /p subconfirm="Do you want to install Visual Studio 2022? (heavy,slow) (Y/n): "
    if /i "%subconfirm%"=="Y" (
        echo --- Install Visual Studio 2022 (Desktop development with C++ workload)
        choco upgrade visualstudio2022community --package-parameters "--add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended" -y --timeout 0
    ) else (
        echo Skipping Visual Studio 2022 installation.
    )

    set /p subconfirm="Do you want to install additional tools and utilities? (y/n): "
    if /i "%subconfirm%"=="y" (
        echo --- Install Notepad++
        choco upgrade notepadplusplus -y

        echo --- Install ffmpeg
        choco upgrade ffmpeg -y
    ) else (
        echo Skipping additional tools and utilities installation.
    )
     
) else (
    echo Skipping developer packages installation.
)



:: ----------------------------------------------------------
:: ----------Update packages---------------------------------
:: ----------------------------------------------------------
echo --- Upgrade all packages
choco upgrade all -y



:: Pause the script to view the final state
pause
:: Restore previous environment settings
endlocal
:: Exit the script successfully
exit /b 0