# Find lates module in PSgallery
Find-Module Rubrik 

#Install Module
Install-Module Rubrik 

#use module
import-module Rubrik

# set variable for my rubrik cluster (can also be IP address)
$RubrikCluster="edge.vdutchy.lab"

# get credentials from saved encrypted xml file
$Credxmlpath = "C:\rubrikCreds.xml"
$CredXML = Import-Clixml $Credxmlpath

# connect to cluster
Connect-Rubrik -Server $RubrikCluster -Credential $CredXML

#get SLA information
Get-RubrikSLA Forward 

#Get more detailed info of SLA
Get-RubrikSLA Forward | select *

#Change hourly retention number of days from 1 day to 21 days in verbose mode
Get-RubrikSLA Forward  | Set-RubrikSLA -HourlyRetention 21 -Verbose

#change back again
Get-RubrikSLA Forward  | Set-RubrikSLA -HourlyRetention 1

# Get all SLA information
$RubrikSLAs = Get-RubrikSLA
$RubrikSLAs

 # lets make it more readable
$RubrikSLAs | Sort-Object name | Select name

# Get Virtual machines 
$RubrikVMs = Get-RubrikVM
$RubrikVMs | Sort-Object name #Show the VM
$RubrikVMs | Sort-Object name | Select name,id #Show the VM name and ID only

# Lets focus on R2D2 to create an on-demand snapshop
# find the ID of the VM R2D2
$RubrikVMID = $RubrikVMs | Where {$_.name -eq “R2D2”} | Select -ExpandProperty id
$RubrikVMID

# Take a backup of the VM and use another SLA, in this case forward. 

New-RubrikSnapshot -id $RubrikVMID -SLA Forward -Confirm:$false


#What functions available
Get-Command -module Rubrik 
#search on specific function for example sla
Get-Command -module Rubrik *sla*






