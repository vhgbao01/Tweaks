@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ----------------------------------------------------------
:: Admin check
:: ----------------------------------------------------------
fltmc >nul 2>&1 || (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ----------------------------------------------------------
:: Install Chocolatey
:: ----------------------------------------------------------
echo Installing Chocolatey...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Set-ExecutionPolicy Bypass -Scope Process -Force; ^
[System.Net.ServicePointManager]::SecurityProtocol = ^
[System.Net.ServicePointManager]::SecurityProtocol -bor 3072; ^
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

:: Add Chocolatey to permanent PATH if missing
echo %PATH% | find /I "%ALLUSERSPROFILE%\chocolatey\bin" >nul
if errorlevel 1 (
    setx PATH "%PATH%;%ALLUSERSPROFILE%\chocolatey\bin" /M >nul
)

call "%ALLUSERSPROFILE%\chocolatey\bin\refreshenv.cmd"

:: ----------------------------------------------------------
:: Package selection
:: ----------------------------------------------------------
set "PACKAGES="

set /p confirm="Install Chocolatey helpers (GUI, choco-cleaner, sudo)? (y/n): "
if /i "!confirm!"=="y" (
    set "PACKAGES=!PACKAGES! chocolateygui choco-cleaner gsudo"
)

set /p confirm="Install runtimes (DirectX, VC++ Redist Full)? (y/n): "
if /i "!confirm!"=="y" (
    set "PACKAGES=!PACKAGES! directx vcredist-all"
)

set /p confirm="Install driver tools (Snappy Driver Installer)? (y/n): "
if /i "!confirm!"=="y" (
    set "PACKAGES=!PACKAGES! sdio"
)

set /p confirm="Install multimedia tools (K-Lite Codec Pack Standard, WinRAR, 7-Zip)? (y/n): "
if /i "!confirm!"=="y" (
    set "PACKAGES=!PACKAGES! k-litecodecpack-standard winrar 7zip"
)

set /p confirm="Install core dev tools (VSCode, Git, Github Desktop, Python, NodeJS, .NET SDK)? (y/n): "
if /i "!confirm!"=="y" (
    set "PACKAGES=!PACKAGES! vscode git github-desktop python nodejs-lts dotnet-sdk"
)

set /p confirm="Install virtualization tools (Docker Desktop, WSL)? (Warning: Heavy and slow) (y/n): "
if /i "!confirm!"=="y" (
    set "PACKAGES=!PACKAGES! docker-desktop"
    powershell -NoProfile -Command "wsl --install --no-distribution"
)

echo.
echo Selected packages:
echo !PACKAGES!
echo.

set /p confirm="Proceed with installation? (y/n): "
if /i not "!confirm!"=="y" exit /b

:: ----------------------------------------------------------
:: Install all packages
:: ----------------------------------------------------------
if defined PACKAGES (
    choco upgrade !PACKAGES! -y --no-progress
)

choco-cleaner

pause
endlocal
exit /b 0