# parameters
param(
    [Parameter(Mandatory=$true)]$vc_server,
    [Parameter(Mandatory=$true)]$vm_name,
    [Parameter(Mandatory=$true)]$vc_username,
    [Parameter(Mandatory=$true)]$vc_password
)

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

# Regular expression pattern to match IPv4 addresses
$ipv4Pattern = "^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

Connect-VIServer -Server $vc_server -Password $vc_password -User $vc_username

$timeout = 300   # Max wait time in seconds
$interval = 10   # Check interval in seconds
$endTime = (Get-Date).AddSeconds($timeout)

while ((Get-Date) -lt $endTime) {
    $vm = Get-VM -Name $vm_name -ErrorAction SilentlyContinue

    if ($vm) {
        $ipAddresses = $vm.Guest.IPAddress

        # Filter IPv4 addresses using the regular expression pattern
        $ipv4Addresses = $ipAddresses | Where-Object { $_ -match $ipv4Pattern }

        if ($ipv4Addresses.Count -gt 0) {
            break
        }
    }

    Start-Sleep -Seconds $interval
}

Disconnect-VIServer -Server $vc_server -Confirm:$false

if ((Get-Date) -ge $endTime) {
    Write-Output "Timeout: IP not available within $timeout seconds."
    exit
}

Write-Output "OUTPUT:$($ipv4Addresses[0])"
