#!/bin/bash
set -euo pipefail

function usage {
    echo ""
    echo "usage: $0 <k8s size>"
    echo ""
    echo "  where <k8s size> is one of"
    echo ""
    echo "    - small, medium, large, xlarge"
    echo ""
}

if [ $# -eq 0 ]
then
    usage
    exit 1
fi

if [ "$1" == "small" ]
then
    variable_master_hosts="masters"
    variable_worker_hosts="no_workers"
    varible_cpu_per_node="2"
    varible_memory_per_node="2"
elif [ "$1" == "medium" ]
then
    variable_master_hosts="masters"
    variable_worker_hosts="worker1"
    varible_cpu_per_node="4"
    varible_memory_per_node="4"
elif [ "$1" == "large" ]
then
    variable_master_hosts="masters"
    variable_worker_hosts="workers"
    varible_cpu_per_node="4"
    varible_memory_per_node="4"
elif [ "$1" == "xlarge" ]
then
    variable_master_hosts="masters"
    variable_worker_hosts="workers"
    varible_cpu_per_node="4"
    varible_memory_per_node="8"
else
    usage
    exit 1
fi

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${SCRIPT_DIR}"/generic.sh

ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
    -i "${inventory_full_path_lab}" \
    --extra-vars "cluster_size=$1" \
    --extra-vars "variable_master_hosts=$variable_master_hosts" \
    --extra-vars "variable_worker_hosts=$variable_worker_hosts" \
    --extra-vars "varible_cpu_per_node=$varible_cpu_per_node" \
    --extra-vars "varible_memory_per_node=$varible_memory_per_node" \
    dell.daf.k8s_deploy.yml 
