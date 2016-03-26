@echo off
setlocal

goto main

:: Functions

:buildSubdir

pushd %1
for /f %%p in ('dir /b /s project.json') do (
    set projectFile=%%p
    dnu restore "%projectFile%"
    dnu build "%projectFile%"
    dnu pack "%projectFile%"
)
popd
goto :EOF

:main

:: Check for dnu
where dnu > NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo dnu wasn't found in your PATH! 1>&2
    echo See http://docs.asp.net/en/latest/getting-started/installing-on-windows.html for instructions on installing the DNX toolchain on your PC. 1>&2
    exit /b %ERRORLEVEL%
)

:: Do the actual work
cd %~dp0
call :buildSubdir src
call :buildSubdir test
