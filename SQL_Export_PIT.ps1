import-module Rubrik
# set parameters
$RubrikCluster="emea1-rbk01.rubrikdemo.com"

# credential file

$Credxmlpath = "/Users/hbuter/rubrik.cred"
$CredXML = Import-Clixml $Credxmlpath

Connect-Rubrik -Server $RubrikCluster -Credential $CredXML

#Set variables
$SourceSQLHost = 'em1-harobute-w1'
$SourceSQLInstance = 'MSSQLSERVER'
$dbname = 'AdventureWorks2016'
$TargetSQLHost = 'em1-harobute-w1'
$TargetSQLInstance = 'MSSQLSERVER'
$TargetDBName = 'Export_ADVWorks16'
$SourceDbid = (Get-RubrikDatabase -HostName $SourceSQLHost -Instance $SourceSQLInstance -Database $dbname)

$RecoveryDateTime = Get-RubrikDatabaseRecoveryPoint -id $SourceDbid.id -RestoreTime "2021-02-28 10:00:00"

#Get target instance ID
$Targetinstanceid = (Get-RubrikSQLInstance -Hostname $TargetSQLHost -Instance $TargetSQLInstance.id)

#Run export
Export-RubrikDatabase -id $SourceDbid.id -recoveryDateTime $RecoveryDateTime -finishRecovery -targetInstanceId $Targetinstanceid.id  -targetDatabaseName $TargetDBName -targetdatafilepath 'C:\SQLData' -targetlogfilepath 'C:\SQLLogs' -maxDataStreams 4