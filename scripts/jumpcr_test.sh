#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${SCRIPT_DIR}"/generic.sh

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <jumpcr_version>"
    exit 1
fi

data_domain_for_testing=ddvault
cr_ova_for_testing=dellemc-cyber-recovery-19.15.0.2-33.ova

export VC_USERNAME=administrator@home.local
export VC_PASSWORD=M@r1n@yc@rl0S
export ESXI_USERNAME=root
export ESXI_PASSWORD=VMware1!
export SYSADMIN_USERNAME=sysadmin
export SYSADMIN_PASSWORD=Pa%w0rd123
# A value of False indicates that the OVA es for release (no inventory files for testing)
export JUMPCR_COMPILE_FOR_TESTING=True

ansible-playbook --vault-password-file "${SCRIPT_DIR}/../vault_pass.txt" --extra-vars "ansible_sudo_pass=${sudo_pass}" \
    -i "${inventory_full_path_lab}" \
    --extra-vars "variable_ova_to_test=jumpcr-$1.ova" \
    --extra-vars "variable_hosts=$data_domain_for_testing" \
    --extra-vars "cr_ova_to_test=$cr_ova_for_testing" \
    dell.daf.jumpcr_test.yml
