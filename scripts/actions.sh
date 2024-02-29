#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

export ASIBLE_COLLECTION_PATH="${SCRIPT_DIR}/../collections/ansible_collections"

inventory_lab="${SCRIPT_DIR}/../playbooks/inventory/inventory_lab.yml"

sudo_pass=$(cat "${SCRIPT_DIR}"/../sudo_pass.txt)

# Get realpath in case we don't have it. It is needed to upload to gitea
inventory_full_path_lab="$(realpath "${inventory_lab}")"
export inventory_full_path_lab

function usage {
    echo "usage: $0 <lab> <action>"
    echo ""
    echo "  where 'lab' is one of"
    echo "    - k8s"
    echo "    - cr"
    echo "    - dns"
    echo "    - samba"
    echo "    - esxis"
    echo "    - avamar"
    echo "    - ai"
    echo " "
    echo "  where 'action' is one of"
    echo "    - stop"
    echo "    - start"
    echo "    - destroy"
    echo "    - take-snapshot/del-snapshot/revert-snapshot (snapshot_name)"
}

if [ $# -lt 2 ]
then
    usage
    exit 1
else
    usecase=$1
    action=$2
fi

set -o nounset

case "${usecase}" in
    # labs
    k8s)
        if [ "$action" == "take-snapshot" ] || [ "$action" == "del-snapshot" ] || [ "$action" == "revert-snapshot" ]
        then
            if [ $# -lt 3 ]
            then
                echo ""
                echo "Snapshot name is required for this action"
                echo ""
                usage
                exit 1
            else
                snapshot_name=$3
            fi
        else
            snapshot_name="not_used"
        fi
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            -i "${inventory_full_path_lab}" \
            --extra-vars "action=$action" \
            --extra-vars "snapshot_name=${snapshot_name}" \
            --extra-vars "variable_hosts=8ks_lab" \
            dell.daf.lab_actions.yml
        ;;
    cr)
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            -i "${inventory_full_path_lab}" \
            --extra-vars "action=$action" \
            --extra-vars "variable_hosts=cr_lab" \
            dell.daf.lab_actions.yml
        ;;
    samba)
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            -i "${inventory_full_path_lab}" \
            --extra-vars "action=$action" \
            --extra-vars "variable_hosts=samba" \
            dell.daf.lab_actions.yml
        ;;

    dns)
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            -i "${inventory_full_path_lab}" \
            --extra-vars "action=$action" \
            --extra-vars "variable_hosts=dns" \
            dell.daf.lab_actions.yml
        ;;
    esxis)
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            -i "${inventory_full_path_lab}" \
            --extra-vars "action=$action" \
            --extra-vars "variable_hosts=esxis" \
            dell.daf.lab_actions.yml
        ;;
    avamar)
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            -i "${inventory_full_path_lab}" \
            --extra-vars "action=$action" \
            --extra-vars "variable_hosts=avamarvault:avamarprod" \
            dell.daf.lab_actions.yml
        ;;
    ai)
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            -i "${inventory_full_path_lab}" \
            --extra-vars "action=$action" \
            --extra-vars "variable_hosts=ai" \
            dell.daf.lab_actions.yml
        ;;
    *)
        usage
        exit 1
        ;;
esac
