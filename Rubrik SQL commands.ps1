#install Rubrik Module
    Install-Module Rubrik

# set parameters
    $RubrikCluster="emea1-rbk01.rubrikdemo.com"
    $dbHost="em1-harobute-w1"
    $dbName="AdventureWorks2016"

# get credentials from saved encrypted xml file
    $Credxmlpath = "C:\Users\harold.buter\Documents\rubrik.cred"
    $CredXML = Import-Clixml $Credxmlpath

# connect to cluster
    Connect-Rubrik -Server $RubrikCluster -Credential $CredXML

# livemount database
    $db=Get-RubrikDatabase -HostName $dbHost -Instance MSSQLSERVER -Database $dbName
    New-RubrikDatabaseMount -id $db.id -targetInstanceId $db.instanceId -mountedDatabaseName 'SQL_LM' -recoveryDateTime (Get-date (Get-RubrikDatabase -id $db.id).latestRecoveryPoint)


# list SQL databases in cluster
    Get-RubrikDatabase |select name,state,instancename,recoverymodel

# List SQL instances in cluster
    Get-RubrikSQLInstance | select name,id,version



