#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

export ASIBLE_COLLECTION_PATH="${SCRIPT_DIR}/../collections/ansible_collections"

inventory_lab="${SCRIPT_DIR}/../playbooks/inventory/inventory_lab.yml"

sudo_pass=$(cat "${SCRIPT_DIR}"/../sudo_pass.txt)
ansible_win_user_pass=$(cat "${SCRIPT_DIR}"/../ansible_win_user_pass.txt)
export ANSIBLE_WIN_USER_PASS="${ansible_win_user_pass}"

# Get realpath in case we don't have it
inventory_full_path_lab="$(realpath "${inventory_lab}")"
export inventory_full_path_lab

function usage {
    echo "usage: $0 <lab>"
    echo ""
    echo "  where lab is one of"
    echo "    - k8s [small medium large xlarge]"
    echo "    - cr"
    echo "    - dns"
    echo "    - esxis"
    echo "    - avamar"
    echo "    - passwords"
    echo "    - jumphost [name]"
    echo "    - tools [present/absent]"
}

if [ $# -eq 0 ]
then
    usage
    exit 1
fi

usecase="$1"

set -o nounset

case "${usecase}" in
    # labs
    k8s)
        if [ $# -eq 2 ]
        then
            if [ "$2" == "small" ]
            then
                variable_master_hosts="masters"
                variable_worker_hosts="no_workers"
                varible_cpu_per_node="2"
                varible_memory_per_node="2"
            fi
            if [ "$2" == "medium" ]
            then
                variable_master_hosts="masters"
                variable_worker_hosts="worker1"
                varible_cpu_per_node="4"
                varible_memory_per_node="4"
            fi
            if [ "$2" == "large" ]
            then
                variable_master_hosts="masters"
                variable_worker_hosts="workers"
                varible_cpu_per_node="4"
                varible_memory_per_node="4"
            fi
            if [ "$2" == "xlarge" ]
            then
                variable_master_hosts="masters"
                variable_worker_hosts="workers"
                varible_cpu_per_node="4"
                varible_memory_per_node="8"
            fi
        else
            usage
            exit 1        
        fi
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            --extra-vars "cluster_size=$1" \
            --extra-vars "variable_master_hosts=$variable_master_hosts" \
            --extra-vars "variable_worker_hosts=$variable_worker_hosts" \
            --extra-vars "varible_cpu_per_node=$varible_cpu_per_node" \
            --extra-vars "varible_memory_per_node=$varible_memory_per_node" \
            -i "${inventory_full_path_lab}" \
            dell.daf.k8s_deploy.yml
        ;;
    cr)
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            -i "${inventory_full_path_lab}" \
            "${SCRIPT_DIR}/../playbooks/deploy_lab_cr.yml"
        ;;
    dns)
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            -i "${inventory_full_path_lab}" \
            dell.daf.dns_deploy.yml
        ;;
    esxis)
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            -i "${inventory_full_path_lab}" \
            dell.daf.esxi_deploy.yml
        ;;
    avamar)
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            -i "${inventory_full_path_lab}" \
            "${SCRIPT_DIR}/../playbooks/deploy_avamar.yml"
        ;;
    passwords)
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            -i "${inventory_full_path_lab}" \
            dell.daf.secrets.yml
        ;;
    jumphost)
        if [ $# -eq 2 ]
        then
            variable_host=$2
        else
            echo "This option requires the host from inventory to be deployed"
            echo "marina"
            usage
            exit 1
        fi
        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            -i "${inventory_full_path_lab}" \
            --extra-vars "variable_hosts=$variable_host" \
            dell.daf.jumphost_deploy.yml
        ;;
    tools)
        variable_hosts="kubeapps:jenkins:gitlab:concourse:gitea:harbor:minio:prometheus:grafana"
        if [ $# -eq 3 ]
        then
            variable_hosts="$2"
            reconcile_state="$3"
        else
            reconcile_state="present"
            if [ $# -eq 2 ]
            then
                variable_hosts="$2"
            else
                echo "Deploying all tools: $variable_hosts"
            fi
        fi

        ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
            --extra-vars "variable_hosts=$variable_hosts" \
            --extra-vars "reconcile_state=$reconcile_state" \
            -i "${inventory_full_path_lab}" \
            dell.daf.tools.yml
        ;;
    *)
        usage
        exit 1
        ;;
esac
