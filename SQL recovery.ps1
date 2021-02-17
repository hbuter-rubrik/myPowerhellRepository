#install & Import Rubrik Module
    #Install-Module Rubrik
    Import-Module Rubrik

# set parameters
    $RubrikCluster="RUBRIK-CLUSTER"
    $dbHost="SOURCEHOST"
    $sourceInstance="INSTANCE"
    $targetHost="TARGETHOST"
    $targetInstance="INSTANCE"
    $dbName="DATABASE"

# get credentials from saved encrypted xml file
    $Credxmlpath = "/Users/hbuter/rubrik.cred"
    $CredXML = Import-Clixml $Credxmlpath

# connect to cluster
    Connect-Rubrik -Server $RubrikCluster -Credential $CredXML

# get info for hosts / databases
$db=Get-RubrikDatabase -HostName $dbHost -Instance $sourceInstance -Database $dbName
$tdb=Get-RubrikDatabase -HostName $targetHost -Instance $targetInstance

# livemount database
New-RubrikDatabaseMount -id $db.id -targetInstanceId $tdb.instanceId -mountedDatabaseName 'PSDEMO_SQL_LiveMount' -recoveryDateTime (Get-date (Get-RubrikDatabase -id $db.id).latestRecoveryPoint)

# Database ID 
Write-Output $db.id

# show livemount of database
get-rubrikdatabasemount -MountedDatabaseName "PSDEMO_SQL_LiveMount"
