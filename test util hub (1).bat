@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

:menu
chcp 65001 >nul
title actualizat! ( v1.5 )
call :banner


:banner
echo.
echo.

echo                     [38;2;255;0;0m ██╗   ██╗████████╗██╗██╗     ██╗████████╗██╗   ██╗    ██╗  ██╗██╗   ██╗██████╗[0m 
echo                     [38;2;255;64;0m ██║   ██║╚══██╔══╝██║██║     ██║╚══██╔══╝╚██╗ ██╔╝    ██║  ██║██║   ██║██╔══██╗[0m 
echo                     [38;2;255;128;0m ██║   ██║   ██║   ██║██║     ██║   ██║    ╚████╔╝     ███████║██║   ██║██████╔╝[0m 
echo                     [38;2;255;191;0m ██║   ██║   ██║   ██║██║     ██║   ██║     ╚██╔╝      ██╔══██║██║   ██║██╔══██╗[0m 
echo                     [38;2;255;223;0m ╚██████╔╝   ██║   ██║███████╗██║   ██║      ██║       ██║  ██║╚██████╔╝██████╔╝[0m 
echo                     [38;2;255;255;0m  ╚═════╝    ╚═╝   ╚═╝╚══════╝╚═╝   ╚═╝      ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ [0m 
echo.

echo.

echo [38;2;255;255;0m  ^>[0m [38;2;255;255;255m  [0] - Update Utility Hub[0m
echo [38;2;255;255;0m  ^>[0m [38;2;255;255;255m  [1] - Check IP Address[0m
echo [38;2;255;255;0m  ^>[0m [38;2;255;255;255m  [2] - Check System Info[0m
echo [38;2;255;255;0m  ^>[0m [38;2;255;255;255m  [3] - Clear Network Cache[0m
echo [38;2;255;255;0m  ^>[0m [38;2;255;255;255m  [4] - Verify System Files[0m
echo [38;2;255;255;0m  ^>[0m [38;2;255;255;255m  [5] - Delete Temporary Files[0m
echo [38;2;255;255;0m  ^>[0m [38;2;255;255;255m  [6] - Show Connected Wi-Fi Passwords[0m
echo [38;2;255;255;0m  ^>[0m [38;2;255;255;255m  [7] - View Advanced TaskList[0m
echo [38;2;255;255;0m  ^>[0m [38;2;255;255;255m  [8] - Task Killer[0m
echo [38;2;255;255;0m  ^>[0m [38;2;255;255;255m  [9] - Random Password Generator[0m


echo.
echo.
echo.
echo.
echo.

SET option=
SET /P option= [38;2;255;255;0mOption:  [0m

IF /I "%option%"=="1" (
    GOTO checkip
) ELSE IF /I "%option%"=="2" (
    GOTO sysinfo
) ELSE IF /I "%option%"=="3" (
    GOTO cnetworkcache	
) ELSE IF /I "%option%"=="4" (
    GOTO sfcscannow
) ELSE IF /I "%option%"=="5" (
    GOTO deltempfiles
) ELSE IF /I "%option%"=="6" (
    GOTO showifipass
) ELSE IF /I "%option%"=="7" (
    GOTO viewtasklist
) ELSE IF /I "%option%"=="8" (
    GOTO taskkiller
) ELSE IF /I "%option%"=="9" (
    GOTO randpassgen
) ELSE IF /I "%option%"=="0" (
    GOTO updateutil
) ELSE (
    echo [38;2;255;0;0mInvalid Option or NaN. Press enter to return.[0m
    pause >nul
    cls
    GOTO menu
)


:sysinfo
systeminfo
GOTO stop

:checkip
echo.
echo.
for /f "delims=" %%i in ('curl -s checkip.amazonaws.com') do set "ip_address=%%i"
echo [38;2;255;255;255mYour IP address is:[0m [38;2;255;255;0m%ip_address%[0m
GOTO stop

:cnetworkcache
ipconfig /flushdns
GOTO stop

:sfcscannow
sfc /scannow
GOTO stop

:deltempfiles
del /q /f /s %temp%\*
del /s /q C:\Windows\temp*
GOTO stop

:showifipass
set /p variabila="Enter the Wi-Fi name: "
netsh wlan show profile name=%variabila% key=clear
GOTO stop

:viewtasklist
tasklist
GOTO stop

:taskkiller
echo.
echo.
set /p pid=Enter Process ID to kill: 
taskkill /PID %pid% /F
GOTO stop

:randpassgen
setlocal enabledelayedexpansion
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
set "password="
for /L %%i in (1,1,12) do (
    set /a "rand=!random! %% 62"
    for %%j in (!rand!) do set "password=!password!!chars:~%%j,1!"
)
echo Generated password: %password%
GOTO stop

:updateutil


:stop
pause
cls
GOTO menu