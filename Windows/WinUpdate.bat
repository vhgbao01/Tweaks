@echo off
echo Choose an option:
echo 1. Disable Windows Update
echo 2. Enable Windows Update
set /p option=Enter option number:

if "%option%"=="1" (
    call :disableUpdate
) else if "%option%"=="2" (
    call :enableUpdate
) else (
    echo Invalid option. Please enter 1 or 2.
    pause
    exit /b
)

:disableUpdate
echo Disabling Windows Update...

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul 2>&1
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
net stop dosvc >nul 2>&1
net stop cryptsvc >nul 2>&1
sc config wuauserv start= disabled >nul 2>&1
sc config bits start= disabled >nul 2>&1
sc config dosvc start= disabled >nul 2>&1
sc config cryptsvc start= disabled >nul 2>&1


echo Windows Update has been disabled.
pause
exit /b

:enableUpdate
echo Enabling Windows Update...

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /f >nul 2>&1
sc config wuauserv start= manual >nul 2>&1
sc config bits start= manual >nul 2>&1
sc config dosvc start= manual >nul 2>&1
sc config cryptsvc start= auto >nul 2>&1
net start cryptsvc >nul 2>&1

echo Windows Update has been enabled.
pause
exit /b
