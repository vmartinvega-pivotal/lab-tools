# parameters
param(
    [Parameter(Mandatory=$true)]$vc_server,
    [Parameter(Mandatory=$true)]$vc_username,
    [Parameter(Mandatory=$true)]$vc_password,
    [Parameter(Mandatory=$true)]$datastore,
    [Parameter(Mandatory=$true)]$source_path,
    [Parameter(Mandatory=$true)]$target_path
)

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

Connect-VIServer -Server $vc_server -Password $vc_password -User $vc_username

$dat = Get-Datastore -Name $datastore

# Create a mapped drive for the datastore
New-PSDrive -Location $dat -Name DS -PSProvider VimDatastore -Root "\" | Out-Null

# Construct the full path to the source file on the datastore
$fullSourcePath = "DS:/$source_path"

# Download the file from the datastore
Copy-DatastoreItem -Item $fullSourcePath -Destination $target_path -Force -Confirm:$false

Remove-PSDrive -Name DS -Confirm:$false

Disconnect-VIServer -Server $vc_server -Confirm:$false
