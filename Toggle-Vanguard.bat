@echo off
setlocal enabledelayedexpansion

REM Enhanced Vanguard Toggle Script
REM Allows users to temporarily disable/enable Riot Vanguard when not gaming

title Riot Vanguard Toggle Utility
color 0A

REM Check for administrative privileges
net session >nul 2>&1
if !errorlevel! neq 0 (
    echo.
    echo ======================================
    echo   ADMINISTRATIVE PRIVILEGES REQUIRED
    echo ======================================
    echo.
    echo This script needs to run as administrator to manage system services.
    echo Requesting elevated permissions...
    echo.
    
    REM Create UAC elevation script
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    set "params=%*"
    echo UAC.ShellExecute "cmd.exe", "/c cd ""%~sdp0"" && ""%~s0"" %params%", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
    
    "%temp%\GetAdmin.vbs"
    del "%temp%\GetAdmin.vbs" >nul 2>&1
    exit /b
)

REM Define variables
set "VANGUARD_DIR=%PROGRAMFILES%\Riot Vanguard"
set "LOG_DIR=%VANGUARD_DIR%\Logs"
set "BACKUP_SUFFIX=.inactive"

REM Display header
echo.
echo ========================================
echo        RIOT VANGUARD TOGGLE UTILITY
echo ========================================
echo.

REM Validate Vanguard installation
if not exist "%VANGUARD_DIR%" (
    echo [ERROR] Riot Vanguard directory not found!
    echo.
    echo Expected location: %VANGUARD_DIR%
    echo.
    echo Please ensure Riot Vanguard is installed or check installation path.
    echo.
    pause
    exit /b 1
)

REM Change to Vanguard directory
pushd "%VANGUARD_DIR%" || (
    echo [ERROR] Failed to access Vanguard directory.
    pause
    exit /b 1
)

REM Determine current Vanguard state
if exist "vgk.sys" (
    set "VANGUARD_STATE=ENABLED"
    set "ACTION=DISABLE"
    set "ACTION_VERB=disable"
) else if exist "vgk.sys%BACKUP_SUFFIX%" (
    set "VANGUARD_STATE=DISABLED"
    set "ACTION=ENABLE"
    set "ACTION_VERB=enable"
) else (
    echo [ERROR] Cannot determine Vanguard state. Installation may be corrupted.
    echo.
    pause
    popd
    exit /b 1
)

REM Display current status and prompt user
echo Current Status: Vanguard is !VANGUARD_STATE!
echo.
echo Would you like to !ACTION_VERB! Riot Vanguard?
echo.
echo [Y] Yes, !ACTION_VERB! Vanguard
echo [N] No, exit without changes
echo.
choice /c YN /n /m "Your choice: "

if !errorlevel! equ 2 (
    echo.
    echo Operation cancelled by user.
    popd
    exit /b 0
)

echo.
echo ========================================

if "!ACTION!"=="DISABLE" (
    REM Disable Vanguard
    echo Disabling Riot Vanguard...
    echo.
    
    REM Stop services gracefully
    echo [1/5] Stopping Vanguard services...
    sc stop vgc >nul 2>&1
    sc stop vgk >nul 2>&1
    timeout /t 2 /nobreak >nul
    
    REM Terminate processes
    echo [2/5] Terminating Vanguard processes...
    taskkill /f /im vgtray.exe >nul 2>&1
    taskkill /f /im vgc.exe >nul 2>&1
    taskkill /f /im vgm.exe >nul 2>&1
    
    REM Disable services
    echo [3/5] Disabling services...
    sc config vgc start= disabled >nul 2>&1
    sc config vgk start= disabled >nul 2>&1
    
    REM Backup files by renaming
    echo [4/5] Backing up Vanguard files...
    set "backup_count=0"
    for %%f in ("installer.exe", "log-uploader.exe", "vgc.exe", "vgc.ico", "vgk.sys", "vgrl.dll", "vgtray.exe", "vgm.exe") do (
        if exist "%%f" (
            if exist "%%f%BACKUP_SUFFIX%" del "%%f%BACKUP_SUFFIX%" >nul 2>&1
            ren "%%f" "%%~nxf%BACKUP_SUFFIX%" >nul 2>&1
            if !errorlevel! equ 0 set /a backup_count+=1
        )
    )
    
    REM Clear logs
    echo [5/5] Cleaning up logs...
    if exist "%LOG_DIR%" (
        rd /s /q "%LOG_DIR%" >nul 2>&1
    )
    
    echo.
    echo ========================================
    echo SUCCESS: Vanguard has been disabled!
    echo.
    echo - !backup_count! files backed up
    echo - Services stopped and disabled
    echo - System resources freed
    echo.
    echo NOTE: You'll need to re-enable Vanguard before playing Riot games.
    
) else (
    REM Enable Vanguard
    echo Enabling Riot Vanguard...
    echo.
    
    REM Restore files
    echo [1/3] Restoring Vanguard files...
    set "restore_count=0"
    for %%f in (*%BACKUP_SUFFIX%) do (
        set "original_name=%%f"
        set "original_name=!original_name:%BACKUP_SUFFIX%=!"
        ren "%%f" "!original_name!" >nul 2>&1
        if !errorlevel! equ 0 set /a restore_count+=1
    )
    
    REM Re-enable services
    echo [2/3] Re-enabling services...
    sc config vgc start= demand >nul 2>&1
    sc config vgk start= system >nul 2>&1
    
    echo [3/3] Vanguard restoration complete.
    
    echo.
    echo ========================================
    echo SUCCESS: Vanguard has been enabled!
    echo.
    echo - !restore_count! files restored
    echo - Services re-enabled
    echo.
    echo IMPORTANT: A system restart is required for changes to take effect.
    echo.
    echo Would you like to restart your computer now?
    echo.
    echo [Y] Yes, restart now
    echo [N] No, restart later manually
    echo.
    choice /c YN /n /m "Your choice: "
    
    if !errorlevel! equ 1 (
        echo.
        echo Restarting system in 5 seconds...
        echo Press Ctrl+C to cancel.
        timeout /t 5
        shutdown /r /f /t 0
    ) else (
        echo.
        echo Please remember to restart your computer before playing Riot games.
    )
)

echo.
echo ========================================
popd
pause