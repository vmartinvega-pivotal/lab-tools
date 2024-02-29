#!/bin/bash
set -euo pipefail

function usage {
    echo ""
    echo "usage: $0 <jump hosts to deploy>"
    echo ""
    echo "  where <jump hosts to deploy> is one of"
    echo ""
    echo "    - marina, jumpwin, jumplab, ai, darkweb, zorin"
    echo ""
}

if [ $# -eq 0 ]
then
    usage
    exit 1
fi

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${SCRIPT_DIR}"/generic.sh

ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
    -i "${inventory_full_path_lab}" \
    --extra-vars "variable_hosts=$1" \
    dell.daf.jumphost_deploy.yml 
