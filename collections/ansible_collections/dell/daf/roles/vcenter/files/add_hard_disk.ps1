# parameters
param(
    [Parameter(Mandatory=$true)]$vc_server,
    [Parameter(Mandatory=$true)]$vc_username,
    [Parameter(Mandatory=$true)]$vc_password,
    [Parameter(Mandatory=$true)]$datastore,
    [Parameter(Mandatory=$true)]$vm_name,
    [Parameter(Mandatory=$true)]$vm_hard_disk_capacity_gb,
    [Parameter(Mandatory=$true)]$disk_persistence,
    [Parameter(Mandatory=$true)]$storage_format
)

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

Connect-VIServer -Server $vc_server -Password $vc_password -User $vc_username

New-HardDisk -VM $vm_name -Persistence $disk_persistence -CapacityGB $vm_hard_disk_capacity_gb -Datastore $datastore -StorageFormat $storage_format

Disconnect-VIServer -Server $vc_server -Confirm:$false
