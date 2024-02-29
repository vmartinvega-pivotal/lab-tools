# parameters
param(
    [Parameter(Mandatory=$true)]$vc_server,
    [Parameter(Mandatory=$true)]$vc_username,
    [Parameter(Mandatory=$true)]$vc_password,
    [Parameter(Mandatory=$true)]$vm_name,
    [Parameter(Mandatory=$true)]$vm_cpus
)

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

Connect-VIServer -Server $vc_server -Password $vc_password -User $vc_username

$vm = Get-VM -Name $vm_name

Set-VM -VM $vm -NumCPU $vm_cpus -Confirm:$false

Disconnect-VIServer -Server $vc_server -Confirm:$false
