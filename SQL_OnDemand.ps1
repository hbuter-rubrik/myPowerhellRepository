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

    # get id from SLA domain so we can run the a backup using SLAID
    $sla=Get-RubrikSLA -Name $dbSla -PrimaryClusterId local
    
# check ID's
    Write-Output "The Database ID is: " $db.id
    Write-Output "The SLA ID is: " $sla.id 

# Take an On demand SQL backup
    New-RubrikSnapshot -id $db.id -slaid $sla.id 