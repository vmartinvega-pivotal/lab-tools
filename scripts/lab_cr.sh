#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${SCRIPT_DIR}"/generic.sh

source "${SCRIPT_DIR}"/cr_deploy.sh crvault
source "${SCRIPT_DIR}"/cr_setup.sh crvault
source "${SCRIPT_DIR}"/cr_users.sh crvault
source "${SCRIPT_DIR}"/dd_deploy.sh ddvault:ddprod
source "${SCRIPT_DIR}"/dd_users_and_mtrees.sh ddvault:ddprod
source "${SCRIPT_DIR}"/cr_storage.sh crvault
source "${SCRIPT_DIR}"/ppdm_deploy.sh ppdmprod
echo "Deploy Power Protect Data Manager from web UI..."
read -n 1 -s -r -p "Press any key to continue when completed..."
source "${SCRIPT_DIR}"/ppdm_setup.sh ppdmprod
source "${SCRIPT_DIR}"/ppdm_deploy_client.sh testlinuxvm
source "${SCRIPT_DIR}"/ppdm_setup_after_client.sh ppdmprod
