@echo off
setlocal EnableDelayedExpansion

set Config=Release
:: CMD can't capture the output of functions unfortunately, so we
:: have to make a variable containing the commands we want to run
set "ListProjects=dir /a-d /b /s project.json | findstr /v /i /c:bin /c:obj"

goto ParseOptions

:: Functions

:BuildSubdir

for %%d in (%*) do (
    pushd "%%d"
    for /f "delims=" %%p in ('!ListProjects!') do call dnu pack "%%p" --configuration "!Config!"
    popd
)
goto :EOF

:CheckInstalled

for %%p in (%*) do (
    set "Program=%%p"
    where "!Program!" > NUL 2>&1
    if !ERRORLEVEL! NEQ 0 (
        echo !Program! wasn't found in your PATH! 1>&2
        echo See http://docs.asp.net/en/latest/getting-started/installing-on-windows.html for instructions on installing the DNX toolchain on your PC. 1>&2
        exit /b !ERRORLEVEL!
    )
)
goto :EOF

:Restore

for %%d in (%*) do (
    pushd "%%d"
    :: dnu is a batch script, so we need to `call` it
    for /f "delims=" %%p in ('!ListProjects!') do call dnu restore "%%p"
    popd
)
goto :EOF

:RunTests

for %%d in (%*) do (
    pushd "%%d"
    for /f "delims=" %%p in ('!ListProjects!') do dnx -p "%%p" test
    popd
)
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
call :CheckInstalled dnu dnx

:: Do the actual work
cd "%~dp0"
call :Restore src test
call :BuildSubdir src
call :RunTests test
