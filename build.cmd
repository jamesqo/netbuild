@echo off
setlocal enableDelayedExpansion

set config=Release
set listProjects=dir /a-d /b /s project.json ^^^| findstr /v /i /c:bin /c:obj

goto parseOptions

:: Functions

:buildSubdir

pushd %1
for /f "delims=" %%p in ('%listProjects%') do call dnu pack "%%p" --configuration "%config%"
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

:restore

pushd %1
:: dnu is a batch script, so we need to `call` it
for /f "delims=" %%p in ('%listProjects%') do call dnu restore "%%p"
popd
goto :EOF

:runTests

pushd %1
for /f "delims=" %%p in ('call :listProjects %*') do dnx -p "%%p" test
popd
goto :EOF

:: Entry point
:parseOptions

if "%~1" == "" goto parsingDone

if "%~1" == "-c" (
    shift
    set config=%1
    goto parseOptions
)

if "%~1" == "--config" (
    shift
    set config=%1
    goto parseOptions
)

shift
goto parseOptions

:parsingDone

:: Check for dnu and dnx
call :checkInstalled dnu
call :checkInstalled dnx

:: Do the actual work
cd %~dp0
call :restore src
call :restore test
call :buildSubdir src
call :runTests test
