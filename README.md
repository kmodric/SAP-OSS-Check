# SAP-OSS-Check
Nagios plugin for checking SAP OSS


## Command line: check_saposs.sh 

## Description: 
This plugin will attempt to connect to SAPOSS server on SAP via saprouter 

Please check SAP Note 182308 - Incorrect logon data in R/3 destination SAPOSS 
 
## Notes: 
- This plugin requires that the sapinfo program is installed 

You can test SAPOSS conection running sapinfo with following options 

$ sapinfo mshost=/H//S/3299/H/194.117.106.129/S/3299/H/oss001 r3name=OSS group=EWA client=001 user=OSS_RFC passwd=CPIC 
 
## Parameters: 
$1 - saprouter 
 
## Example of command definitions for nagios: 

define command { 
 
  command_name check_saposs 
  
  command_line /usr/lib/nagios/plugins/check_saposs.sh $ARG1$ 

} 
 

##Please set SAPINFO_HOME to the directory where you installed sapinfo 
SAPINFO_HOME="/opt/rfcsdk/bin" 
 
