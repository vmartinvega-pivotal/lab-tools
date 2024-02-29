# Folder where all portable apps will be unzipped
$cr_apps_destination_path="C:\Program Files\CR_APPS"

# Do no touch this. That is the folder that contains the apps that can be installed
$root_folder_tools = $PSScriptRoot + "\..\tools"

function InstallMsi{
    Param(
        [Parameter (Mandatory = $true)] 
        [String]$file_path,
        [Parameter (Mandatory = $true)]
        [String]$arguments
    )
    if (Test-Path $file_path){
        Start-Process -Wait -FilePath "$file_path" -ArgumentList "$arguments" -passthru
    }
    else{
        Write-Host "Skipping the installation for: '$file_path'"
    }
}

function InstallPortable{
    Param(
        [Parameter (Mandatory = $true)]
        [String]$file_path,
        [Parameter (Mandatory = $true)]
        [String]$destination
    )
    if (Test-Path $file_path){
        Expand-Archive -Path "$file_path" -DestinationPath "$destination"
    }
    else{
        Write-Host "Skipping the installation for: '$file_path'"
    }
}

InstallMsi -file_path "$root_folder_tools\ChromeStandaloneSetup64.exe" -arguments "/install /silent"
InstallMsi -file_path "$root_folder_tools\CSViewer.exe" -arguments "/install /silent"

InstallPortable -file_path "$root_folder_tools\csvfileview.zip" -destination "$cr_apps_destination_path"
InstallPortable -file_path "$root_folder_tools\Firefox.zip" -destination "$cr_apps_destination_path"
InstallPortable -file_path "$root_folder_tools\KeePass-v2.53.1.zip" -destination "$cr_apps_destination_path"
InstallPortable -file_path "$root_folder_tools\MobaXterm-v23.0.zip" -destination "$cr_apps_destination_path"