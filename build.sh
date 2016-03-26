#!/usr/bin/env bash

build_subdir()
{
    find "$1" -type f -name project.json -print0 |
    while read -rd '' projectfile
    do
        dnu restore "$projectfile"
        dnu build "$projectfile"
        dnu pack "$project file"
    done
}

type dnu > /dev/null 2>&1 || (echo "dnu isn't in your PATH!" 1>&2 && exit 1)

scriptdir=$(dirname "$0")
cd -P "$scriptdir"

build_subdir src
build_subdir test
