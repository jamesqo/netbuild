#!/usr/bin/env bash

build_subdir()
{
    find "$1" -type f -name project.json |
    grep -Ev '[Bb]in|[Oo]bj' |
    while read -r projectfile
    do
        dnu restore "$projectfile"
        dnu pack "$projectfile" --configuration "$conf"
    done
}

fail()
{
    echo "$@" 1>&2
    exit 1
}

run_tests()
{
    find "$1" -type f -name project.json |
    grep -Ev '[Bb]in|[Oo]bj' |
    xargs -i dnx -p {} test
}

conf=Release

# Parse options
while [ $# -gt 0 ]
do
    case "$1" in
        -c|--config)
            shift
            conf=$1
            ;;
    esac
    shift
done

# Check prereqs
type dnu > /dev/null 2>&1 || fail "dnu isn't in your PATH!"
type dnx > /dev/null 2>&1 || fail "dnx isn't in your PATH!"

scriptdir=$(dirname "$0")
cd -P "$scriptdir"

build_subdir src
build_subdir test
run_tests test
