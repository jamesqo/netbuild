@echo off
setlocal EnableDelayedExpansion

set Config=Release
set "ListProjects=dir /a-d /b /s project.json ^| findstr /v /i /c:bin /c:obj"

goto ParseOptions

:: Functions

:BuildSubdir

pushd %1
for /f "delims=" %%p in ('%ListProjects%') do call dnu pack "%%p" --configuration "%Config%"
popd
goto :EOF

:CheckInstalled

where %1 > NUL 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo %1 wasn't found in your PATH! 1>&2
    echo See http://docs.asp.net/en/latest/getting-started/installing-on-windows.html for instructions on installing the DNX toolchain on your PC. 1>&2
    exit /b %ERRORLEVEL%
)
goto :EOF

:Restore

pushd %1
:: dnu is a batch script, so we need to `call` it
for /f "delims=" %%p in ('%ListProjects%') do call dnu restore "%%p"
popd
goto :EOF

:RunTests

pushd %1
for /f "delims=" %%p in ('%ListProjects%') do dnx -p "%%p" test
popd
goto :EOF

:: Entry point
:ParseOptions

if "%~1" == "" goto ParsingDone

if "%~1" == "-c" (
    shift
    set "Config=%~1"
    goto ParseOptions
)

if "%~1" == "--config" (
    shift
    set "Config=%~1"
    goto ParseOptions
)

shift
goto ParseOptions

:ParsingDone

:: Check for dnu and dnx
call :CheckInstalled dnu
call :CheckInstalled dnx

:: Do the actual work
cd %~dp0
call :Restore src
call :Restore test
call :BuildSubdir src
call :RunTests test
