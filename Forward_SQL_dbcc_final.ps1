#install & Import Rubrik & SQL Module
    #Install-Module Rubrik
    Import-Module Rubrik
    import-module SQLServer

# set parameters
    $RubrikCluster="edge.vdutchy.lab"
    $dbHost="solo"
    $dbName="AdventureWorks"
    $lmName="PSDEMO_SQL_LM"

# get Rubrik credentials from saved encrypted xml file
    $Credxmlpath = "C:\rubrikCreds.xml"
    $RubrikCredXML = Import-Clixml $Credxmlpath
    $SQLCredxmlpath = "C:\SQLCreds.xml"
    $SQLCredXML = Import-Clixml $SQLCredxmlpath

# connect to cluster
    write-output "Connect to Rubrik Cluster"
    Connect-Rubrik -Server $RubrikCluster -Credential $RubrikCredXML
    write-output "Connected to Rubrik Cluster $RubrikCluster"

# livemount database
    write-output "Start SQL DB Livemount of latest snapshot of $dbName"
    $db=Get-RubrikDatabase -HostName $dbHost -Instance MSSQLSERVER -Database $dbName
    $request=New-RubrikDatabaseMount -id $db.id -targetInstanceId $db.instanceId -mountedDatabaseName $lmName -recoveryDateTime (Get-date (Get-RubrikDatabase -id $db.id).latestRecoveryPoint)

#wait for 5 seconds before continuing the script
    start-sleep -Seconds 5

# wait for it until livemount has status running
    $id = $request.id
    while ((Get-RubrikRequest -id $id -type "mssql").status -eq "RUNNING") { Start-Sleep -Seconds 1 }
    Write-Output "Live Mount of completed!, Livemount name is $lmName"


# show livemount of database
    get-rubrikdatabasemount -MountedDatabaseName $lmName


# Next session is courtesy of Josh Stenhouse #
# Remote SQL default MSSQLSERVER instance using sa login
$RemoteDefaultSQLInstance  = "solo"

#####################################################################
# Nothing to change below this line, commented throughout to explain
#####################################################################
##############################################
# Checking to see if the SqlServer module is already installed, if not installing it for the current user
##############################################
$SQLModuleCheck = Get-Module -ListAvailable SqlServer
if ($SQLModuleCheck -eq $null)
{
write-host "SqlServer Module Not Found - Installing"
# Not installed, trusting PS Gallery to remove prompt on install
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
# Installing module
Install-Module -Name SqlServer –Scope CurrentUser -Confirm:$false -AllowClobber
}
##############################################
# Importing the SqlServer module
##############################################
Import-Module SqlServer
##############################################
# Creating SQL Query to get the size of all DBs on each Instance
##############################################
# Change this to whatever you want to test, but this is a good one to start with!
$SQLDBQuery = "dbcc checkdb($lmName)"

############################################################################################
# Example 3 - Remote SQL with SA Authentication
############################################################################################
##############################################
# Testing query against Remote SQL default MSSQLSERVER instance using sa login
##############################################
# Running the SQL Query, setting result of query to $False if any errors caaught
Try 
{
# Setting to null first to prevent seeing previous query results
$SQLDBQueryResult = $null
# Running the query
#$SQLDBQueryResult = Invoke-SqlCmd -Query $SQLDBQuery -ServerInstance $RemoteDefaultSQLInstance -Username $RemoteDefaultSQLInstanceUser -Password $RemoteDefaultSQLInstancePassword
$SQLDBQueryResult = Invoke-SqlCmd -Query $SQLDBQuery -ServerInstance $RemoteDefaultSQLInstance -credential $SQLCredXML
# Setting the query result
$SQLQuerySuccess = "Success"
}
Catch 
{
# Overwriting result if it failed
$SQLQuerySuccess = "Failed"
}

# Output of the results for you to see
"SQLDBCC Check database: $lmName"
"SQLQueryResult: $SQLQuerySuccess"

$SQLDBSizeResult

# Clean up live mount
    Write-output "Removing the livemount $lmName"
    $lmdb=get-rubrikdatabasemount -MountedDatabaseName $lmName
    Remove-RubrikDatabaseMount -id $lmdb.id
    Write-output "All done"


##############################################
# End of script
##############################################
