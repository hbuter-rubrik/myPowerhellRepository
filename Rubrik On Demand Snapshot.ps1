#install & Import Rubrik Module
Install-Module Rubrik
Import-Module Rubrik

# set parameters
$RubrikCluster="emea1-rbk01.rubrikdemo.com"
$VM="em1-harobute-l1"



# get credentials from saved encrypted xml file
$Credxmlpath = "/Users/hbuter/rubrik.cred"
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
$SLA="4hr-30d-AWS"
New-RubrikSnapshot -id $RubrikVMID -SLA "$SLA" -Confirm:$false

