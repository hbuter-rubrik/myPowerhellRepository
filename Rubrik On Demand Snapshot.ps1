#Import Rubrik Module
Import-Module Rubrik

# set parameters
$RubrikCluster="emea1-rbk01.rubrikdemo.com"
$VM="em1-harobute-l1"
$SLA="4hr-30d-AWS"
$Credxmlpath = "/Users/hbuter/rubrik.cred"

# get credentials from saved encrypted xml file
$CredXML = Import-Clixml $Credxmlpath

# connect to cluster
Connect-Rubrik -Server $RubrikCluster -Credential $CredXML

# show SLA's available in the cluster
$RubrikSLAs=Get-RubrikSLA
$RubrikSLAs | Sort-object name | select name,numProtectedObjects

# Show VMs available in cluster with their ID
$RubrikVMs=Get-RubrikVM
#$RubrikVMs | Sort-Object name | select name,ID

# filter on my VM for snapshot
$RubrikVMID=$RubrikVMs | where{$_.name -eq"$VM"}|select -ExpandProperty id
$RubrikVMID

# create snapshot for my VM
New-RubrikSnapshot -id $RubrikVMID -SLA "$SLA" -Confirm:$false

