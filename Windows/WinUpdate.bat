@echo off

where PowerShell >nul 2>&1 || (
    echo PowerShell is not available. Please install or enable PowerShell.
    pause & exit 1
)
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
)
pause
endlocal
exit /b 0
