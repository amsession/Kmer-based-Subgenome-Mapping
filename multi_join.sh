#!/bin/sh

# multijoin - join multiple files

join_rec() {
    if [ $# -eq 1 ]; then
        join -j 1 -a 1 -a 2 -e '0' -t $'\t' -o auto - "$1"
    else
        f=$1; shift
        join -j 1 -a 1 -a 2 -e '0' -t $'\t' -o auto - "$f" | join_rec "$@"
    fi
}

if [ $# -le 2 ]; then
    join -j 1 -a 1 -a 2 -e '0' -t $'\t' -o auto "$@"
else
    f1=$1; f2=$2; shift 2
    join -j 1 -a 1 -a 2 -e '0' -t $'\t' -o auto "$f1" "$f2" | join_rec "$@"
fi
