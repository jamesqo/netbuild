#!/usr/bin/env bash

build_subdir()
{
    list_projects "$@" |
    xargs -i dnu pack {} --configuration "$config"
}

fail()
{
    echo "$@" 1>&2
    exit 1
}

list_projects()
{
    find "$@" -type f -name project.json |
    grep -Ev '[Bb]in|[Oo]bj'
}

restore_pkgs()
{
    list_projects "$@" | xargs dnu restore
}

run_tests()
{
    list_projects "$@" | xargs -i dnx -p {} test
}

config=Release

# Parse options
while [ $# -gt 0 ]
do
    case "$1" in
        -c|--config)
            shift
            config=$1
            ;;
    esac
    shift
done

# Check prereqs
type dnu > /dev/null 2>&1 || fail "dnu isn't in your PATH!"
type dnx > /dev/null 2>&1 || fail "dnx isn't in your PATH!"

scriptdir=$(dirname "$0")
cd -P "$scriptdir"

restore_pkgs src test
build_subdir src
run_tests test
