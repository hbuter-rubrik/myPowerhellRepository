
# set parameters
$RubrikCluster="emea1-rbk01.rubrikdemo.com"
#$RubrikCreds=Get-Credential

#$credential = $RubrikCreds
#$credential | Export-Clixml -Path "C:\Users\harold.buter\Documents\rubrik.cred"

$Credxmlpath = "/Users/hbuter/rubrik.cred"
$CredXML = Import-Clixml $Credxmlpath

# connect to cluster
Connect-Rubrik -Server $RubrikCluster -Credential $CredXML