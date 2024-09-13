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
set LOG_DIR=%DRIVER_DIR%logs

:: Create the logs directory if it doesn't exist
if not exist "%LOG_DIR%" (
    mkdir "%LOG_DIR%"
)

:: Set the main log file path
set MAIN_LOGFILE=%LOG_DIR%\install_log.txt

:: Log the start time
echo Driver Installation Started at %DATE% %TIME% > %MAIN_LOGFILE%
echo Driver Installation Started at %DATE% %TIME%

:: Log all files in the directory before starting
echo Files in the directory: >> %MAIN_LOGFILE%
echo Files in the directory:
dir %DRIVER_DIR% /b >> %MAIN_LOGFILE%
dir %DRIVER_DIR% /b

:: Iterate over all .exe files in the directory and install them
for %%f in (%DRIVER_DIR%*.exe) do (
    set INDIVIDUAL_LOGFILE=%LOG_DIR%\%%~nf_install_log.txt
    echo Installing %%~nxf >> %MAIN_LOGFILE%
    echo Installing %%~nxf
    %%f /SILENT /NORESTART /CLOSEAPPLICATIONS /LOG="%INDIVIDUAL_LOGFILE%" /LOGCLOSEAPPLICATIONS >> %MAIN_LOGFILE% 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo Failed to install %%~nxf, error code: %ERRORLEVEL% >> %MAIN_LOGFILE%
        echo Failed to install %%~nxf, error code: %ERRORLEVEL%
    ) else (
        echo Successfully installed %%~nxf >> %MAIN_LOGFILE%
        echo Successfully installed %%~nxf
    )
)

:: Log the completion time
echo Driver Installation Completed at %DATE% %TIME% >> %MAIN_LOGFILE%
echo Driver Installation Completed at %DATE% %TIME%

endlocal
