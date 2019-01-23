#!/usr/local/bin/bash
#
# SCRIPT: snmp.sh
# DATE:   14-MAR-2005
# REV:    1.1.A (Valid are A, B, D, T and P)
#               (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: (SPECIFY: AIX, HP-UX, Linux, Solaris
#                      or Not platform dependent)
#
# PURPOSE: Runs snmpcollect against host
#
#
# set -n   # Uncomment to check your syntax, without execution.
#          # NOTE: Do not forget to put the comment back in or
#          #       the shell script will not execute!
# set -x   # Uncomment to debug this shell script (Korn shell only)
#

shopt -s extglob

##########################################################
########### DEFINE FILES AND VARIABLES HERE ##############
##########################################################

community=$1
device=$2
snmpcollect="snmpcollect.$device"
snmpmibs="snmpmibs.$device"
cat /dev/null > $snmpcollect
cat /dev/null > $snmpmibs

##########################################################
############### DEFINE FUNCTIONS HERE ####################
##########################################################

function collect_mib
{
        snmpwalk -v2c -c $community $device > $snmpcollect
        cat $snmpcollect | grep "=" | awk -F "=" '{ print$1 }' > $snmpmibs
}

function query_mib
{
        while read line
        do
                snmpget -v2c -c $community $device $line 2>&1 > /dev/null
                sleep 1
        done < $snmpmibs
}



##########################################################
################ BEGINNING OF MAIN #######################
##########################################################

collect_mib

while true
do
        query_mib
done



# End of script
