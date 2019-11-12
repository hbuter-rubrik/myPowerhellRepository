
# set parameters
$RubrikCluster="emea1-rbk01.rubrikdemo.com"
#$RubrikCreds=Get-Credential

$credential = Get-Credential
Connect-Rubrik -Server $RubrikCluster -Credential $credential
$credential | Export-Clixml -Path "/Users/hbuter/rubrik.cred"

# use new created credential file to authenticate and connect to cluster
$Credxmlpath = "/Users/hbuter/rubrik.cred"
$CredXML = Import-Clixml $Credxmlpath
Connect-Rubrik -Server $RubrikCluster -Credential $CredXML