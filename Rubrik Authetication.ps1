#install Rubrik Module
Install-Module Rubrik

# set parameters
$RubrikCluster="emea1-rbk01.rubrikdemo.com"
$Credxmlpath = "C:\Users\harold.buter\Documents\rubrik.cred"
$CredXML = Import-Clixml $Credxmlpath

# connect to cluster
Connect-Rubrik -Server $RubrikCluster -Credential $CredXML
