<#
.SYNOPSIS
Add Virtual Machines into a custom role

.DESCRIPTION
Input the role you want to amend and the VM you want to add into the custom role. The script will retrieve the ID for the 
for the role and use invoke-RubrikRESTcall to add the VM ID into the role.
The privileges for the role can be be amended. this script adds the VM to 5 privileges, however you can change these to the specific privileges from the role you like to amend

.NOTES
written by Harold Buter for community usage
Twitter: @hbuter
GitHub: hbuter-rubrik
#>


# Import Rubrik Module
import-Module Rubrik

# Parameters
$RubrikCluster="emea1-rbk01.rubrikdemo.com"
$roleName = "Harold-Test"
$vm2Add = "em1-harobute-l1"

# get credentials from saved encrypted xml file
$Credxmlpath = "/Users/hbuter/rubrik.cred"
$CredXML = Import-Clixml $Credxmlpath

# connect to cluster
Connect-Rubrik -Server $RubrikCluster -Credential $CredXML

# Get Id for role
$roleBody = Invoke-RubrikRESTCall -Endpoint 'role' -Method GET -Query @{'name'=$roleName}
$roleID = $roleBody.data.roleId

# Get information on the role itself
$roleInfo = Invoke-RubrikRESTCall -api internal -Endpoint role/$roleID/authorization -Method GET | Select-Object -ExpandProperty authorizationSpecifications
Write-Output $roleInfo

# Get ID from VM to add to the role
$VMID=(get-rubrikvm -name $vm2Add -PrimaryClusterID local|  Where-Object {$_.isRelic -ne 'TRUE'}).id
Write-Output = $VMID


# add the VM to the role
$body = @{
    "roleTemplate" = "EndUser";
    "authorizationSpecifications" = @(
        @{
            "privilege" = "ManageProtection";
            "resources" = @($VMID);
        },
        @{
            "privilege" = "FileRestore";
            "resources" = @($VMID);
        },
        @{
            "privilege" = "LiveMount";
            "resources" = @($VMID);
        },
        @{
            "privilege" = "OnDemandSnapshot";
            "resources" = @($VMID);
        },
        @{
            "privilege" = "Export";
            "resources" = @($VMID);
        }
    )
};
​
Invoke-RubrikRESTCall -api internal -Endpoint role/$roleID/authorization -Method POST -Body $body







