@echo off
setlocal EnableDelayedExpansion

:Build

pushd "%~dp0"
call build -c Release

:NuGet

set "BinDir=%~dp0bin"
set "NuGetExe=%BinDir%\nuget.exe"
set "NuGetUrl=http://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

if exist "%NuGetExe%" goto Publish

echo Restoring NuGet...
if not exist "%BinDir%" mkdir "%BinDir%"
powershell -NoProfile -ExecutionPolicy Bypass "(New-Object Net.WebClient).DownloadFile('%NuGetUrl%', '%NuGetExe%')"

:Publish

cd src
for /f "delims=" %%d in ('dir /b /ad') do (
    pushd "%%d\bin\Release"
    del /q *.symbols.nupkg
    "!NuGetExe!" push *.nupkg
    del /q *.nupkg
    popd
)

:Done

popd
echo Your packages have been published.
