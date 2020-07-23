# Find lates module in PSgallery
Find-Module Rubrik 

#Install Module
Install-Module Rubrik 

#use module
import-module Rubrik

# set variable for my rubrik cluster (can also be IP address)
$RubrikCluster="emea1-rbk01.rubrikdemo.com"

# get credentials from saved encrypted xml file
$Credxmlpath = "/Users/hbuter/rubrik.cred"
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

#What functions available
Get-Command -module Rubrik 
#search on specific function for example sla
Get-Command -module Rubrik *sla*

#backup validation usecase
Install-Module -Name Rubrik
Install-Module -Name RubrikBackupValidation
Install-Module -Name VMware.Powercli
Install-Module -Name InvokeBuild




