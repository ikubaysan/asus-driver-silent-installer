@echo off
setlocal

:: Check for Administrator permissions
NET SESSION >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Requesting administrative privileges...
    :: Re-run the script with elevated permissions
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Get the directory where the batch file is located
set DRIVER_DIR=%~dp0
set LOGFILE=%DRIVER_DIR%install_log.txt

:: Log the start time
echo Driver Installation Started at %DATE% %TIME% > %LOGFILE%
echo Driver Installation Started at %DATE% %TIME%

:: Log all files in the directory before starting
echo Files in the directory: >> %LOGFILE%
echo Files in the directory:
dir %DRIVER_DIR% /b >> %LOGFILE%
dir %DRIVER_DIR% /b

:: Iterate over all .exe files in the directory and install them
for %%f in (%DRIVER_DIR%*.exe) do (
    echo Installing %%~nxf >> %LOGFILE%
    echo Installing %%~nxf
    %%f /SILENT /NORESTART /CLOSEAPPLICATIONS /LOG="%LOGFILE%" /LOGCLOSEAPPLICATIONS /SUPPRESSMSGBOXES >> %LOGFILE% 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo Failed to install %%~nxf, error code: %ERRORLEVEL% >> %LOGFILE%
        echo Failed to install %%~nxf, error code: %ERRORLEVEL%
    ) else (
        echo Successfully installed %%~nxf >> %LOGFILE%
        echo Successfully installed %%~nxf
    )
)

:: Log the completion time
echo Driver Installation Completed at %DATE% %TIME% >> %LOGFILE%
echo Driver Installation Completed at %DATE% %TIME%

endlocal
