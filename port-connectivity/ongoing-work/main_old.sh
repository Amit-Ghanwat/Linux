#!/bin/bash

#USERNAME=$1
#inputfile=$2
#checktype=$3

echo -ne "Enter your Username:\n"
read username
USERNAME=$username

echo -ne "Enter your password:\n"
read -s pass
password=$pass

#echo -ne "Enter the name of ScanInput File:\n"
#read scaninput
#inputfile=$scaninput

echo -ne "Enter the checktype (Pre_Source/Pre_Target/Post):\n"
read CheckType
checktype=$CheckType

local_script="/home/admin2316/port-connectivity/portconnectivity.py"
#arguments="-inputfile $inputfile -checktype $checktype"
output_dir="/home/admin2316/port-connectivity/output"

while read server;
do
   #echo -e "\n"
   echo "~~~~~~ Connecting to $server ~~~~~~"
   sshpass -p "$password" scp "$local_script" ""$server"_PortScanInput.csv" "$server":~/
   sshpass -p "$password" ssh -n -tt -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$USERNAME"@"$server" "python ~/portconnectivity.py -inputfile "$server"_PortScanInput.csv -checktype "$checktype""
   sshpass -p "$password" scp "$server":~/"$server"*.CSV "$output_dir"
   echo -e "\n "
done < serverlist

echo "All remote scripts have been executed and output files have been transferred to the local output directory."
