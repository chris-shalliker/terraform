#Requires -Version 3.0

#-------------------------------------[Changable Variables]-------------------------------------

# Set Azure part of the DNS name
[string]$azureDNS = ".cloudapp.azure.com"

 # Set the settings.json file location
[string]$settingsFile = "/tmp/settings.json"

# Create replicated.conf variables
[string]$licenceFileLocation = "/tmp/license.rli"
[string]$repTmpDir = "/tmp/replicated.conf"
[bool]$setToTrue = $true;

# Password
[string]$password = "VMware1!"

#-------------------------------------[Set Common Variables]-------------------------------------
# Get time
[string]$timelog = Get-Date -UFormat %T

# Get date for log file name
[string]$date = Get-Date -f yyyy-MM-dd

# Get time for log file name
[string]$t = Get-Date -UFormat %T
[string]$time = "-T-" + $t -replace ":","."

# Default log file location
[string]$logLocation = "/tmp/"

# Default log file prefix
[string]$logFilePrefix = "Config-Terraform-Azure-"

# Default log file extension
[string]$logFileExtension = ".log"

[string]$LogFileName = $logFilePrefix + $date + $time + $logFileExtension



#-------------------------------------[Code]-------------------------------------
$timelog + "---------- Starting Config-Terraform-Azure Script ---------- " | Out-File -FilePath $logLocation$LogFileName -Append


# Collect metadata from VM
$metaJson = Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -NoProxy -Uri "http://169.254.169.254/metadata/instance?api-version=2020-09-01" | ConvertTo-Json -Depth 10

# Create object
$VMObject = ConvertFrom-Json $metaJson -Depth 10

#Create variables
$adminUsername = $VMObject.compute.osProfile.adminUsername
$compName = $VMObject.compute.name
$location = $VMObject.compute.location
$namePrefixes = $compName.Split($adminUsername)


# Create DNS name
$FQDNS = $namePrefixes[0] + $adminUsername + "." + $location + $azureDNS

"FQDN is: " + $FQDNS | Out-File -FilePath $logLocation$LogFileName -Append

 # Create the settings.json file data
$tfeHostname = [ordered]@{
    "Value"=$FQDNS;
}

$installation_type = [ordered]@{
    "Value"="poc";
}

$enc_password = [ordered]@{
    "Value"=$password;
}

$setData = [ordered]@{
    "hostname"=$tfeHostname;
    "installation_type"=$installation_type;
    "enc_password"=$enc_password;
}

# Create new setData json object
$setDataJson = $setData | ConvertTo-Json | Out-File -FilePath "/tmp/setdata.json" 
[PSCustomObject]$setImport = Get-content -Path "/tmp/setdata.json" | ConvertFrom-Json

# Import settings file into a new object
[PSCustomObject]$jsonImport = Get-content -Path "/tmp/settings-incomplete.json" | ConvertFrom-Json

# Combine existing settings.json with settings data into new object.
$newSettings = new-object psobject
($jsonImport | Get-Member | Where-Object{$PSItem.membertype -eq "NoteProperty"} | Select-Object -expandproperty name) | ForEach-Object{ $newSettings | Add-Member -MemberType NoteProperty -name $PSItem -value $jsonImport.$PSItem -Force}
($setImport | Get-Member | Where-Object{$PSItem.membertype -eq "NoteProperty"} | Select-Object -expandproperty name) | ForEach-Object{ $newSettings | Add-Member -MemberType NoteProperty -name $PSItem -value $setImport.$PSItem -Force}
            
# Convert to Json and export
$newSettings | ConvertTo-Json | Out-File -FilePath $settingsFile
"Settings.json file has been created: " + $setJson | Out-File -FilePath $logLocation$LogFileName -Append


 # Create the replicated.conf file
$repData = [ordered]@{
    "DaemonAuthenticationType"="password";
    "DaemonAuthenticationPassword"=$password;
    "TlsBootstrapType"="self-signed";
    "TlsBootstrapHostname"=$FQDNS;
    "BypassPreflightChecks"=$setToTrue;
    "ImportSettingsFrom"=$settingsFile;
    "LicenseFileLocation"=$licenceFileLocation;
}


# Convert to Json and export
$repData | ConvertTo-Json | Out-File -FilePath $repTmpDir
"Replicated.conf file has been created: " | Out-File -FilePath $logLocation$LogFileName -Append

Move-Item -Path $repTmpDir -Destination /etc/replicated.conf -Force

# Get time
[string]$timelog = Get-Date -UFormat %T

$timelog + "---------- Script Finished ----------" | Out-File -FilePath $logLocation$LogFileName -Append


