#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${SCRIPT_DIR}"/generic.sh

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <jumpcr_version>"
    exit 1
fi

"${SCRIPT_DIR}"/jumpcr_deploy.sh "$@"

"${SCRIPT_DIR}"/jumpcr_test.sh "$@"
