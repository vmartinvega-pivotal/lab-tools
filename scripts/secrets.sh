#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

export ASIBLE_COLLECTION_PATH="${SCRIPT_DIR}/../collections/ansible_collections"

inventory_lab="${SCRIPT_DIR}/../playbooks/inventory/inventory_lab.yml"

sudo_pass=$(cat "${SCRIPT_DIR}"/../sudo_pass.txt)

# Get realpath in case we don't have it. It is needed to upload to gitea
inventory_full_path_lab="$(realpath "${inventory_lab}")"
export inventory_full_path_lab

ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
    -i "${inventory_full_path_lab}" \
    dell.daf.secrets.yml
