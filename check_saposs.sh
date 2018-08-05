#!/bin/bash
#set -x
################################################################################
#
# check_oss plugin for Nagios
#
# Originally Written by Kristijan Modric (kmodric_at_gmail.com)
#
# Created: 29 Nov 2012
#
# Version 1.0 (Kristijan Modric)
#
# Command line: check_saposs.sh <saprouter>
#
# Description:
# This plugin will attempt to connect to SAPOSS server on SAP via saprouter
# Please check SAP Note 182308 - Incorrect logon data in R/3 destination SAPOSS
#
#  Notes:
#   - This plugin requires that the sapinfo program is installed
#   You can test SAPOSS conection running sapinfo with following options
#   $ sapinfo mshost=/H/<saprouter name or IP>/S/3299/H/194.117.106.129/S/3299/H/oss001 r3name=OSS group=EWA client=001 user=OSS_RFC passwd=CPIC
#
#  Parameters:
#  $1 - saprouter
#
#  Example of command definitions for nagios:
#
#       define command {
#        command_name    check_saposs
#        command_line    /usr/lib/nagios/plugins/check_saposs.sh $ARG1$
#       }
#
##############################################################################
#Please set SAPINFO_HOME to the directory where you installed sapinfo
SAPINFO_HOME="/opt/rfcsdk/bin"
##############################################################################


STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4

if [ ! -f $SAPINFO_HOME/sapinfo ];
then
                echo -e "File sapinfo does NOT exists.\nPlease check if the variable SAPINFO_HOME is pointing to the directory where you installed sapinfo."
fi



if [ $# -ne 1 ]; then
echo "Usage: $0 <saprouter>"
echo "Example: $0 <IP address or FQDN of saprouter>"
exit 3
fi

#If failes firs time wait for 15 sec and then try again

result=`$SAPINFO_HOME/sapinfo mshost=/H/$1/S/3299/H/194.117.106.129/S/3299/H/oss001 r3name=OSS group=EWA client=001 user=OSS_RFC passwd=CPIC | strings`


if [[ $result == *"SAP kernel release"* ]]
then
  echo "SAPOSS is working OK! | OSS=1"
 exit $STATE_OK
 else
        sleep 15
result=`$SAPINFO_HOME/sapinfo mshost=/H/$1/S/3299/H/194.117.106.129/S/3299/H/oss001 r3name=OSS group=EWA client=001 user=OSS_RFC passwd=CPIC | strings`
        if [[ $result == *"SAP kernel release"* ]]
        then
          echo "SAPOSS is working OK! | OSS=1"
         exit $STATE_OK
         else
          echo "SAPOSS is NOT working! | OSS=0"
         exit $STATE_CRITICAL
        fi
fi

