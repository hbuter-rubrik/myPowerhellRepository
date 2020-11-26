# myRepository
In this folder you will find snipits of powershell for Rubrik code I am using regulary for my demo's and show the possibilities with Rubrik Automation using powershell  and Rubrik SDK.
(Most scripts will use the MAC credential file, if you use windows based OS, change the path of the credential file in the script to your location where the file is located)

<b>Rubrik create credential file </b>- 
creates encrypted XML authentication file that can be used for authentication against rubrik cluster.

<b>Rubrik Authentication </b>- 
script to login into rubrik cluster using authentication file on a windows based machine

<b>Rubrik Authentication 4 Mac </b>- 
script to login into rubrik cluster using authentication file on a MAC laptop

<b>Rubrik SQL commandd </b>-
v1 - live mount & Show & unmount latest recovery point to SQL server

<b>Rubrik VMware </b>- 
v1 - Live mount & show & unmount latest recovery point from VM defined in parameters

<b>Rubrik unprotected </b>-
show all machines / servers that are not part of a SLA domain and export it to screen or CSV file

<b>Forward & Forward SQL </b>- 
These are scripts used for the Forward presentations. Forward.ps1 are basic rubrik sdk command examples.
Forward_SQL_DBCC.ps1 performs a SQL livemount, wait until it is running and will run a SQL DBCC check. once done the livemount will be removed again.
(Note: Thanks to Josh Stenhouse for parts of this script (to connect to SQL and run a query) )

<b>createCredentials </b>- 
Create encrypted credential files for Rubrik, Vmware and GuestOS, which can be used in the scripts to authenticate without displaying passwords

<b>RubrikVolume_Livemount.ps1 </b>- 
Mount a volume from RBS based backup (physcial or physical) to physical server (or virtual server) adn made visible under the target server c:\Rubrik-mounts\ 

<b>VMDK_Size_Audit.ps1 </b> -
Script from Marcus Henderson @ Rubrik amended to change for v5.2.
Script to find VMDK and Exclude disks in VMware
It will drop the VMs into a CSV file in the event it detects protected VMDKs that are larger than the specified size.  
Common use cases for this is to detect SQL VMs where the database VMDKs have not yet been excluded. 
<ul>
<li><b>EXAMPLE</b>

<code>C:\>.\VMDK_Size_Audit.ps1 -cluster 10.180.23.53 -VMDK_Size 120000000000 -SLA "Bronze"</code>

This will generate a CSV that provides a breakdown of all VMs with protected VMDKs that are members of the Bronze SLA and have a VMDK size greater than 120GB </li>

<li><b>EXAMPLE</b>

<code>C:\>.\VMDK_Size_Audit.ps1 -cluster 10.180.23.53 -Exclude_VMDKs -CSV D:\Rubrik\VMDK_Exclusion_report.csv</code>

This will exclude all VMDKs named in the CSV file. </li>
</ul>
