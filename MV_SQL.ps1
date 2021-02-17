#Step Name: Open VM for Write
# Type: Powershell
# Advanced Settings Retry 3/Wait 3
# Token is gererated from Rubrik API Token Manager
# Ensure MV has the IP address of the server connecting to it (i.e. by default the SQL server doing the backup), you can add multiple IP's if needed.
# Ensure the MV has the Username of the RBS Service doing the SQL backup (i.e. in Demo Lab this is SQL$), you can add multiple USernames if you need to.
# You need to be running the Rubrik Powershell SDK and ensure it is up-to-date with the CDM version.
Import-Module -Name Rubrik    
$RubrikConnection = @{
    Server = 'emea1-rbk01.rubrikdemo.com'      
    Token = ''
}  
$ManagedVolumeName = '[MV_NAME]'    
Connect-Rubrik @RubrikConnection  
$RubrikManagedVolume = Get-RubrikManagedVolume -Name $ManagedVolumeName    
if ($RubrikManagedVolume.isWritable -eq $false){      
    $ManagedVolumeSnapshot = Start-RubrikManagedVolumeSnapshot -id $RubrikManagedVolume.id      
    $ManagedVolumeSnapshot  
}
Step Name: Open VM for Write
# Type: T-SQL
# DatabaseBackup - USER_DATABASES - FULL
# This step is generated for you when you add the Ola Hallengren MaintenanceSolution scripts. https://ola.hallengren.com/sql-server-backup.html
# MV URL is used for the @Directory field
# Edit as needed
EXECUTE [dbo].[DatabaseBackup]
@Databases = 'USER_DATABASES',
@Directory = '\\172.24.37.114\2b5c5327-bab5-4403-b1fb-17eb333a65d2',
@BackupType = 'FULL',
@Verify = 'Y',
@CleanupTime = 24,
@CheckSum = 'Y',
@LogToTable = 'Y'
Step Name: Close MV for Write
# Type: Powershell
# Advanced Settings Retry 3/Wait 3
# $ServerInstance is the name of your SQL instance
Import-Module -Name Rubrik    
$RubrikConnection = @{
    Server = 'emea1-rbk01.rubrikdemo.com'      
    Token = '[TOKEN]' 
}  
$ManagedVolumeName = '[MV_NAME]'  
$ServerInstance = '[Server-name]'  
$JobName = 'DatabaseBackup - USER_DATABASES - FULL' 
$Jobs = Invoke-SQLCMD -ServerInstance $ServerInstance  -Query 'EXEC msdb.dbo.sp_help_job @execution_status = 1'    
if (($Jobs | Where-Object {$_.Name -ne $JobName} | Measure-Object).Count -eq 0 ){
    Connect-Rubrik @RubrikConnection
    $RubrikManagedVolume = Get-RubrikManagedVolume -Name $ManagedVolumeName
    if ($RubrikManagedVolume.isWritable -eq $true){
        $ManagedVolumeSnapshot = Stop-RubrikManagedVolumeSnapshot -id $RubrikManagedVolume.id
        $ManagedVolumeSnapshot      
    } 
}