#!/usr/bin/python

# Make coding more python3-ish
from __future__ import absolute_import, division, print_function

ANSIBLE_METADATA = {
    'metadata_version': '1.1',
    'status': ['preview'],
    'supported_by': 'community'
}

DOCUMENTATION = '''
---
module: esxi_vm

short_description: This module gets the information for an esxi virtual machine.

author:
    - Vicente Martin

description:
    - "This module gets the information for an esxi virtual machine."

options:
    hostname:
        description:
            - esxi/vcenter ip.
        required: true
        type: str
    username:
        description:
            - esxi/vcenter username.
        required: true
        type: str
    password:
        description:
            - esxi/vcenter password.
        required: true
        type: str
    vm_name:
        description:
            - esxi/vcenter vm name.
        required: true
        type: str            
'''

EXAMPLES = '''
- name: Get a vm information that is in an esxi or vcenter
    hostname: 192.168.1.101
    username: administrator@home.local
    password: password
    vm_name: ddvault
  register: vm_information_output
  no_log: true
'''

RETURN = '''
output:
    vm_details: the vm details
    type: dict
    returned: always
'''

__metaclass__ = type

from pyVim.connect import SmartConnect, Disconnect
from pyVmomi import vim
import ssl
import traceback
import time

from ansible.module_utils.basic import AnsibleModule

def main():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        hostname=dict(type='str', required=True),
        username=dict(type='str', required=True),
        password=dict(type='str', required=True),
        vm_name=dict(type='str', required=True),
        retries=dict(type='int', required=False, default=60),
        delay=dict(type='int', required=False, default=5),
        wait_for_ip=dict(type='str', required=False, default=''),
    )
    
    # Will return the vm details or none if not found
    result = dict(
        vm_details=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    hostname  = module.params['hostname']
    if not hostname:
        module.fail_json(msg="The 'hostname' is required.")

    username = module.params['username']
    if not username:
        module.fail_json(msg="The 'username' is required.")

    password = module.params['password']
    if not password:
        module.fail_json(msg="The 'password' is required.")

    vm_name = module.params['vm_name']
    if not vm_name:
        module.fail_json(msg="The 'vm_name' is required.")

    try:
        vm_details = get_vm(hostname, username, password, vm_name)
        attemps = 0
        while not vm_details['found'] or vm_details['ip_addresses'] == [] or (len(module.params['wait_for_ip']) > 0 and module.params['wait_for_ip'] not in vm_details['ip_addresses']):
            time.sleep(int(module.params['delay']))
            attemps=attemps+1
            if attemps >= int(module.params['retries']):
                break
            vm_details = get_vm(hostname, username, password, vm_name)

        result['vm_details'] = vm_details
    except Exception:
        module.fail_json(msg='error' + '.Error: ' + traceback.format_exc())

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)

def get_vm(esxi_ip, username, password, vm_name):
    # Create a context that doesn't check SSL certificates
    context = ssl._create_unverified_context()

    # Connect to the ESXi host
    c = SmartConnect(host=esxi_ip, user=username, pwd=password, sslContext=context)

    # Get all VMs
    content = c.RetrieveContent()
    container = content.viewManager.CreateContainerView(content.rootFolder, [vim.VirtualMachine], True)
    children = container.view

    # Find the VM and return its IP and power state
    ips = []
    for child in children:
        if child.summary.config.name == vm_name:
            for nic in child.guest.net:
                for ip in nic.ipAddress:
                    if ":" not in ip:  # Exclude IPv6 addresses
                        ips.append(ip)
            
            state = child.summary.runtime.powerState
            Disconnect(c)        
            return {
                'ip_addresses': ips,
                'power_state': state,
                'found': True
            }
            
    # Disconnect from the host
    Disconnect(c)
    return {
        'ip_addresses': [],
        'power_state': 'N/A',
        'found': False
    }

if __name__ == '__main__':
    main()
