@echo off

echo Repairing system image, please wait

DISM /Online /Cleanup-Image /CheckHealth

DISM /Online /Cleanup-Image /ScanHealth

DISM /Online /Cleanup-Image /RestoreHealth

DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase

SFC /scannow

echo System repair is finished!

echo. & pause