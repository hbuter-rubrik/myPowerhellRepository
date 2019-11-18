#install & Import Rubrik Module
    #Install-Module Rubrik
    Import-Module Rubrik

# set parameters
    $RubrikCluster="emea1-rbk01.rubrikdemo.com"
    $dbHost="em1-harobute-w1"
    $dbName="AdventureWorks2016"

# get credentials from saved encrypted xml file
    $Credxmlpath = "/Users/hbuter/rubrik.cred"
    $CredXML = Import-Clixml $Credxmlpath

# connect to cluster
    Connect-Rubrik -Server $RubrikCluster -Credential $CredXML

# livemount database
    $db=Get-RubrikDatabase -HostName $dbHost -Instance MSSQLSERVER -Database $dbName
    New-RubrikDatabaseMount -id $db.id -targetInstanceId $db.instanceId -mountedDatabaseName 'PSDEMO_SQL_LM' -recoveryDateTime (Get-date (Get-RubrikDatabase -id $db.id).latestRecoveryPoint)

# show livemount of database
get-rubrikdatabasemount -MountedDatabaseName "PSDEMO_SQL_LM"
    
#Unmount livemount database
    $lmdb=get-rubrikdatabasemount -MountedDatabaseName "PSDEMO_SQL_LM" 
    Remove-RubrikDatabaseMount -id $lmdb.id


# list SQL databases in cluster
    Get-RubrikDatabase |select name,state,instancename,recoverymodel

# List SQL instances in cluster
    Get-RubrikSQLInstance | select name,id,version



