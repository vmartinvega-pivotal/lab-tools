#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${SCRIPT_DIR}"/generic.sh

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <jumpcr_version>"
    exit 1
fi

branch_to_compile=main

ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
    -i "${inventory_full_path_lab}" \
    --extra-vars "jumpcr_version=$1" \
    dell.daf.jumpcr_deploy.yml 

ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
    -i "${inventory_full_path_lab}" \
    --extra-vars "jumpcr_version=$1" \
    --extra-vars "jumpcr_branch_to_compile=$branch_to_compile" \
    dell.daf.jumpcr_compile.yml

ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
    -i "${inventory_full_path_lab}" \
    --extra-vars "jumpcr_version=$1" \
    dell.daf.jumpcr_export.yml

# ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
#     -i "${inventory_full_path_lab}" \
#     --extra-vars "variable_ova_to_test=jumpcr-$1.ova" \
#     dell.daf.jumpcr_test.yml
