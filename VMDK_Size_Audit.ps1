<#
.SYNOPSIS
This script is used to query Rubrik about the individual VMDKs associated with the VMs Rubrik protects. 

It will drop the VMs into a CSV file in the event it detects protected VMDKs that are larger than the specified size.  

Common use cases for this is to detect SQL VMs where the database VMDKs have not yet been excluded. 

.EXAMPLE

C:\>.\VMDK_Size_Audit.ps1 -cluster 10.180.23.53 -VMDK_Size 120000000000 -SLA "Bronze"

This will generate a CSV that provides a breakdown of all VMs with protected VMDKs that are members of the Bronze SLA and have a VMDK size greater than 120GB 

.EXAMPLE

C:\>.\VMDK_Size_Audit.ps1 -cluster 10.180.23.53 -Exclude_VMDKs -CSV D:\Rubrik\VMDK_Exclusion_report.csv

This will exclude all VMDKs named in the CSV file. 

#>

param(
    [cmdletbinding()]
    [parameter(Mandatory=$false)]
    [int]$VMDK_Size,
    [parameter(Mandatory=$false)]
    [string]$SLA,
    [parameter(Mandatory=$false)]
    [switch]$Exclude_VMDKs,
    [parameter(Mandatory=$false)]
    [string]$CSV,
    [parameter(Mandatory=$false)]
    [string]$cluster
    )

Connect-Rubrik -Server $cluster -Verbose:$false

$clustername = (Invoke-RubrikRESTCall -Endpoint cluster/me -Method GET -api 1).name
$mdate = (Get-Date).tostring("yyyyMMddHHmm")


if(!$Exclude_VMDKs){
$VM_list = Get-RubrikVM -SLA $SLA
$VMsToCheck = $VM_list | Where-Object{$_.effectiveSlaDomainId -ne "UNPROTECTED"}
$VMsToCheck
$VMDK_report = @()
$VMDK_stats = @()
Write-Output ("Found " + ($vm_list | Measure-Object).count + " VMs")
Write-Output ("Getting snaps for the protected VMs.  This can take a while if there are many VMs")
$vmindex = 1
ForEach($VM in $VMsToCheck)
{
       Write-Output ("Getting snaps for " + $vm.name)
        Write-Output ("VM " + $vmIndex + " of " + ($VM_list | Measure-Object).count)

$vm_info = Get-RubrikVM -id $VM.id
$VMDKs = $vm_info.virtualDiskIds# | Get-Unique



ForEach($disk in $VMDKs)
{
$disk_stats = Invoke-RubrikRESTCall -Endpoint ("vmware/vm/virtual_disk/" + $disk) -api 1 -Method GET

$stats = New-Object psobject
$stats | Add-Member -NotePropertyName "Name" -NotePropertyValue $VM.name
$stats | Add-Member -NotePropertyName "VM_ID" -NotePropertyValue $VM.id
$stats | Add-Member -NotePropertyName "VMDK_name" -NotePropertyValue $disk_stats.fileName
$stats | Add-Member -NotePropertyName "VMDK_ID" -NotePropertyValue $disk_stats.id
$stats | Add-Member -NotePropertyName "VMDK_Size" -NotePropertyValue $disk_stats.size
$stats | Add-Member -NotePropertyName "Excluded_from_Snapshots" -NotePropertyValue $disk_stats.excludeFromSnapshots

$VMDK_stats +=$stats
}
$vmindex++
$VMDK_report += $VMDK_stats

}

$Protected_VMDKS = $VMDK_report | Where-Object{$_.Excluded_from_Snapshots -match "False"}
#$unique_VMs = $Protected_VMDKS.VM_ID | sort |unique
#$Protected_VMDKS |?{$_.vm_id -eq $unique_VMs[0]}|measure
$csv_data = $Protected_VMDKS | Where-Object{$_.VMDK_Size -gt "$VMDK_Size"}
Write-Output ( "Generating CSV file in present working directory")
$csv_data | Export-Csv -NoTypeInformation VMDK_Exclusion_report.$clustername.$mdate.csv

Write-Output "If you would like to exclude some of these VMDKs simply review the CSV and remove and rows that you would like to keep included in the Rubrik backup. Once done re-run this script with the -Exclude_VMDKs flag using the -CSV flag to specify the csv file you wish to use for the exclusion list."
}
if($Exclude_VMDKs){
    $csv_data = Import-Csv $CSV
    $unique_disks = $csv_data.VMDK_ID | Sort-Object | Get-Unique
    $json_config = @"
    {
        "excludeFromSnapshots": true
    }
"@
$json_config = $json_config | ConvertFrom-Json
    foreach($VMDK_disk in $unique_disks){
        Write-Output ("Excluding VMDK " + $VMDK_disk)
        Invoke-RubrikRESTCall -Endpoint ("vmware/vm/virtual_disk/" + $VMDK_disk) -Method PATCH -Body $json_config -api 1 
    }
}