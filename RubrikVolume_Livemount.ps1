#Import Rubrik Module
Import-Module Rubrik

# set parameters
$RubrikCluster="edge.vdutchy.lab"
$vg="Jumper.vdutchy.lab"
$myTargetServer="Solo"

# get credentials from saved encrypted xml file
$Credxmlpath = "C:\tmp\rubrik.cred"
$CredXML = Import-Clixml $Credxmlpath

# connect to cluster
Connect-Rubrik -Server $RubrikCluster -Credential $CredXML

# Get the snapshot to be used for livemount
$snapshot = Get-RubrikVolumeGroup -hostname $vg | Get-RubrikSnapshot -latest

# mount the volume snapshot to another server (physical or virtual)
New-RubrikVolumeGroupMount -TargetHost $myTargetServer -VolumeGroupSnapshot $snapshot -Verbose

# show the volume group Live mount
Get-RubrikVolumeGroupMount | Where-Object {$_.targetHostName -eq $myTargetServer}

# Remove the VolumeGroup Live mount

# first find the id of the snapshot
$VG_LM = Get-RubrikVolumeGroupMount | Where-Object {$_.targetHostName -eq $myTargetServer}
$ID = $VG_LM.id

# Remove the snapshot
Remove-RubrikVolumeGroupMount -id $ID
