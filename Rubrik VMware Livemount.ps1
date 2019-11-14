#Import Rubrik Module
Import-Module Rubrik

# set parameters
$RubrikCluster="emea1-rbk01.rubrikdemo.com"
$myVM="em1-harobute-w1"
$LiveMountName="$myVM-PSdemoLiveMount"

# get credentials from saved encrypted xml file
$Credxmlpath = "/Users/hbuter/rubrik.cred"
$CredXML = Import-Clixml $Credxmlpath

# connect to cluster
Connect-Rubrik -Server $RubrikCluster -Credential $CredXML

# Live mount VM with latest recovery point
$VMID=(get-rubrikvm -name $myVM |  Where-Object {$_.isRelic -ne 'TRUE'}).id

(Get-RubrikSnapshot -id $VMID -Latest |
        New-RubrikMount -MountName $LiveMountName -PowerOn:$false -RemoveNetworkDevices:$false -DisableNetwork:$false -Confirm:$false).id
    Start-Sleep -Seconds 1

# show info about the live mount VM
    get-rubrikmount -VMID $VMID

# remove the live mount
Get-RubrikMount -VMID $VMID.id | Remove-RubrikMount




