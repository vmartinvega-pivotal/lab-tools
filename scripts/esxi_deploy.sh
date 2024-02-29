#!/bin/bash
set -euo pipefail

function usage {
    echo ""
    echo "usage: $0 <esxis to deploy>"
    echo ""
    echo "  where <esxis to deploy> is one of"
    echo ""
    echo "    - esxi73"
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
    dell.daf.esxi_deploy.yml 
