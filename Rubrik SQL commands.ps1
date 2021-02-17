#install & Import Rubrik Module
    #Install-Module Rubrik
    Import-Module Rubrik

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

# Database ID 
    Write-Output $db.id

# On demand backup
    New-RubrikSnapshot -id $db.id -SLA $dbSla -Confirm:$false

# livemount database
    New-RubrikDatabaseMount -id $db.id -targetInstanceId $db.instanceId -mountedDatabaseName $livemountName -recoveryDateTime (Get-date (Get-RubrikDatabase -id $db.id).latestRecoveryPoint)

# Get Latest RecoveryPoint info
    get-RubrikDatabaseRecoveryPoint -id $db.id -Latest

# show livemount of database
    get-rubrikdatabasemount -MountedDatabaseName $livemountName
    
#Unmount livemount database
    $lmdb=get-rubrikdatabasemount -MountedDatabaseName $livemountName
    Remove-RubrikDatabaseMount -id $lmdb.id

# list SQL databases in cluster
    Get-RubrikDatabase | select name,state,instancename,recoverymodel

# List SQL instances in cluster
    Get-RubrikSQLInstance | select name,id,version



