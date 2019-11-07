@echo off
title %~f0

rem Automatically run by answer file upon first boot after installation

cd /d D:\

start cmd /c "cd updates && "install-updates.bat""
start cmd /c "cd qubes-windows-tools && "allow-unsigned-drivers.bat""
start cmd /c "cd qubes-windows-tools && "install-qwt-startup-task.bat""

rem If the PPID of any cmd.exe is equal to the PID of this process we will wait for them to exit and then shutdown
for /f "tokens=2 usebackq" %%p in (`tasklist /v /fi "IMAGENAME eq cmd.exe" ^| findstr /c:"%~f0"`) do set PID=%%p
:jobs_running
wmic process where (parentprocessid="%PID%" and name="cmd.exe") 2>&1 | findstr /c:"No Instance(s) Available." >nul
if %ERRORLEVEL%==0 (shutdown /s /t 0) else timeout 5 /nobreak && goto jobs_running