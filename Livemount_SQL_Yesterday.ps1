#install & Import Rubrik Module
    #Install-Module Rubrik
    Import-Module Rubrik -RequiredVersion 5.3.0 

# set parameters
    $RubrikCluster="emea1-rbk01.rubrikdemo.com"
    $dbHost="em1-harobute-w1"
    $dbName="AdventureWorks2016"
    $dbInstance="MSSQLSERVER"
    $dbSla="4hr-30d-AWS"
    $livemountName="PSDEMO_SQL_LiveMount"

# get credentials from saved encrypted xml file
    $Credxmlpath = "/Users/hbuter/rubrik.cred"
    $CredXML = Import-Clixml $Credxmlpath

# connect to cluster
    Connect-Rubrik -Server $RubrikCluster -Credential $CredXML

# Set db parameter
    $db=Get-RubrikDatabase -HostName $dbHost -Instance $dbInstance -Database $dbName

# Get a snapshot from yesterday that will be used for Livemount
    $recoverDate=Get-RubrikSnapshot -id $db.id -Date (get-date).AddDays(-1)
    $recoveryDateTime = Get-RubrikDatabaseRecoveryPoint -id $db.id -RestoreTime 

# livemount database using a snapshot created yesterday 
    New-RubrikDatabaseMount -id $db.id -targetInstanceId $db.instanceId -mountedDatabaseName $livemountName -recoveryDateTime $recoverDate.date

# show livemount of database
    get-rubrikdatabasemount -MountedDatabaseName $livemountName
    
#Unmount livemount database
    $lmdb=get-rubrikdatabasemount -MountedDatabaseName $livemountName
    Remove-RubrikDatabaseMount -id $lmdb.id