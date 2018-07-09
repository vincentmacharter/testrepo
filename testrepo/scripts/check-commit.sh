#!/usr/bin/env bash

set -euo pipefail

function usage(){
    echo "Usage: ./$(basename ${0}) current_time"
}

current_time=${1:-}
if [[ -z ${current_time} ]]; then
 >&2 echo "Missing argument 'current time'."
 >&2 usage
 exit 1
fi

commit_hash="$(git log ./testrepo/docker/dummy.txt | awk 'NR==1{print $2}')"
commit_time="$(git show -s --format=%ct ${commit_hash})"
timediff=$(($current_time - $commit_time))

if [[ timediff -lt 300 ]]; then
    echo "Build this thing"
else
    echo "Don't build this thing"
fi
