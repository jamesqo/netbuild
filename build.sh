#!/usr/bin/env bash

build_subdir()
{
    find "$1" -type f -name project.json |
    egrep -v '[Bb]in|[Oo]bj' |
    while read -r projectfile
    do
        dnu restore "$projectfile"
        dnu build "$projectfile"
        dnu pack "$projectfile"
    done
}

run_tests()
{
    find "$1" -type f -name project.json |
    egrep -v '[Bb]in|[Oo]bj' |
    xargs -i dnx -p {} test
}

# Check prereqs
type dnu > /dev/null 2>&1 || (echo "dnu isn't in your PATH!" 1>&2 && exit 1)
type dnx > /dev/null 2>&1 || (echo "dnx isn't in your PATH!" 1>&2 && exit 1)

scriptdir=$(dirname "$0")
cd -P "$scriptdir"

build_subdir src
build_subdir test
run_tests test
