#!/bin/bash
set -euo pipefail

export ASIBLE_COLLECTION_PATH="${SCRIPT_DIR}/../collections/ansible_collections"

inventory_lab="${SCRIPT_DIR}/../playbooks/inventory/inventory_lab.yml"

sudo_pass=$(cat "${SCRIPT_DIR}"/../sudo_pass.txt)
ansible_win_user_pass=$(cat "${SCRIPT_DIR}"/../ansible_win_user_pass.txt)
export ANSIBLE_WIN_USER_PASS="${ansible_win_user_pass}"
export sudo_pass

# Get realpath in case we don't have it
inventory_full_path_lab="$(realpath "${inventory_lab}")"
export inventory_full_path_lab
