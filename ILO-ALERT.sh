#!/bin/bash
#Script to configure ilo mail alert configurations
#Written by Smit Naik, 05/30/2018

display_usage()
        {
        echo '====================================================='
        echo "Usage: step.05.enable_ilo_alertmail.sh host-ilo-ip.txt"
        }
if [  $# -le 0 ] || [  $# -lt 1 ] ||[[ ( $# == "--help") ||  $# == "-h" ]]
    then
        display_usage
        exit 1
    fi

SSH_CMD="ssh -q -o StrictHostKeyChecking=no"
LST=$1
LOG=out.`date +%Y-%m-%d-%H%M`-ilo-email_alert.$$.log
>$LOG

for host in `cat $LST |grep -v "^#"`;
do
  echo "======= MAIL ALERT CONFIGURATION CHANGE ======= "
  echo "ilo Hostname : $host"
  $SSH_CMD administrator@$host "set /map1/oemhp_alertmail1 oemhp_alertmail_enable=yes"|grep "staus_tag"  >>/dev/null
  if [[ $? -ne 0 ]];
  then
    tput -Txterm setf 4
    printf "%-29s\t%s\n" "Enabling Mail Alert : ERROR"
    tput -Txterm sgr 0
  fi

  $SSH_CMD administrator@$host "set /map1/oemhp_alertmail1 oemhp_alertmail_email=ALERTS@abc.com"|grep "status_tag" >>/dev/null
  if [[ $? -ne 0 ]];
  then
    tput -Txterm setf 4
    printf "%-29s\t%s\n" " Setting up correct DL : ERROR"
    tput -Txterm sgr 0
  fi

  $SSH_CMD administrator@$host "set /map1/oemhp_alertmail1 oemhp_alertmail_sender_domain=abc.com"|grep "status_tag">>/dev/null
  if [[ $? -ne 0 ]];
  then
    tput -Txterm setf 4
    printf "%-29s\t%s\n"  " Setting up correct Domain : ERROR "
    tput -Txterm sgr 0
  fi

  $SSH_CMD administrator@$host "set /map1/oemhp_alertmail1 oemhp_alertmail_smtp_server=10.10.10.10"|grep "status_tag">>/dev/null
  if [[ $? -ne 0 ]];
  then
    tput -Txterm setf 4
    printf "%-29s\t%s\n" " Setting up SMTP Server IP : ERROR"
    tput -Txterm sgr 0
  fi

  $SSH_CMD administrator@$host "set /map1/oemhp_alertmail1 oemhp_alertmail_smtp_port=25"|grep "status_tag">>/dev/null
  if [[ $? -ne 0 ]];
  then
    tput -Txterm setf 4
    printf "%-29s\t%s\n" " Setting up SMTP PORT : ERROR"
    tput -Txterm sgr 0
  fi

  echo "===== MAIL ALERT CONFIGURATION POST CHANGE ====="
  $SSH_CMD administrator@$host "show /system1 oemhp_server_name"|grep "name"|awk '{print $NF}'
  $SSH_CMD administrator@$host "show /map1/oemhp_alertmail1" |egrep -i 'enable|email|domain|server|port'
  echo "-----------------------------------------------"
done > $LOG | tee -a $LOG
