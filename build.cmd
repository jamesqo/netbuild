@echo off
setlocal

goto main

:: Functions

:buildSubdir

pushd %1
for /f "delims=" %%p in ('dir /a-d /b /s project.json') do (
    dnu restore "%%p"
    dnu build "%%p"
    dnu pack "%%p"
)
popd
goto :EOF

:checkInstalled

where %1 > NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %1 wasn't found in your PATH! 1>&2
    echo See http://docs.asp.net/en/latest/getting-started/installing-on-windows.html for instructions on installing the DNX toolchain on your PC. 1>&2
    exit /b %ERRORLEVEL%
)
goto :EOF

:runTests
pushd %1
for /f "delims=" %%p in ('dir /a-d /b /s project.json') do (
    :: Exclude bin/ and obj/ directories
    echo %%p | findstr /i /c:bin /c:obj > NUL
    if %ERRORLEVEL% NEQ 0 dnx -p %%p test
)
popd
goto :EOF

:: Entry point
:main

:: Check for dnu and dnx
call :checkInstalled dnu
call :checkInstalled dnx

:: Do the actual work
cd %~dp0
call :buildSubdir src
call :buildSubdir test
call :runTests test
