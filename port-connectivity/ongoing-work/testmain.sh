#!/bin/bash

echo -ne "Enter your Username:\n"
read username
USERNAME=$username

echo -ne "Enter your Password:\n"
read -s pass
password=$pass

echo -ne "Enter the Checktype (Pre_Source/Pre_Target/Post):\n"
read CheckType
checktype=$CheckType

checkt=$(echo "$checktype" | cut -d\_ -f1)
ctype=$(echo "$checktype" | cut -d\_ -f2)

local_script="/home/admin2316/port-connectivity/portconnectivity.py"
output_dir="/home/admin2316/port-connectivity/output"

#echo -ne "Enter path of the PortConnectivity script (To get the path use command- 'find ~ -name portconnectivity.py'):\n"
#read path
#local_script=$path

#echo -ne "Enter path of Output Directory (To get the path cd to your Output directory & use command 'pwd' ):\n"
#read op_path
#output_dir=$op_path

#date=`date "+%d%m%Y"`

while read server;
do
   echo -e "\n"
   date=`date "+%d%m%Y"`
   echo "~~~~~~ Connecting to $server ~~~~~~"
   if [[ $checktype -eq Pre_Source ]];
   then
        sshpass -p "$password" ssh "$USERNAME"@"$server" "mkdir ~/Avanade-PortConnectivity-$checktype-$date"
        sshpass -p "$password" scp "$local_script" ""$server"_PortScanInput.csv" "$USERNAME"@"$server":~/Avanade-PortConnectivity-$checktype-$date
        sshpass -p "$password" ssh -n -tt -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$USERNAME"@"$server" "cd ~/Avanade-PortConnectivity-$checktype-$date; python portconnectivity.py -inputfile ""$server"_PortScanInput.csv" -checktype "$checktype""
        sshpass -p "$password" scp "$USERNAME"@"$server":~/Avanade-PortConnectivity-$checktype-$date/${server}*.CSV "$output_dir"
       : 
        elif [[ $checktype -eq Pre_Target ]];
        then
        sshpass -p "$password" ssh "$USERNAME"@"$server" "mkdir ~/Avanade-PortConnectivity-$checktype-$date"
        sshpass -p "$password" scp "$local_script" ""$server"_PortScanInput.csv" "$USERNAME"@"$server":~/Avanade-PortConnectivity-$checktype-$date
        sshpass -p "$password" ssh -n -tt -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$USERNAME"@"$server" "cd ~/Avanade-PortConnectivity-$checktype-$date; python portconnectivity.py -inputfile ""$server"_PortScanInput.csv" -checktype "$checktype""
        sshpass -p "$password" scp "$USERNAME"@"$server":~/Avanade-PortConnectivity-$checktype-$date/${server}*.CSV "$output_dir"
        :
        elif [[ $checktype -eq Post ]];
        then
        sshpass -p "$password" ssh "$USERNAME"@"$server" "mkdir ~/Avanade-PortConnectivity-$checktype-$date"
        sshpass -p "$password" scp "$local_script" ""$server"_PortScanInput.csv" "$USERNAME"@"$server":~/Avanade-PortConnectivity-$checktype-$date
        sshpass -p "$password" ssh -n -tt -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$USERNAME"@"$server" "cd ~/Avanade-PortConnectivity-$checktype-$date; python portconnectivity.py -inputfile ""$server"_PortScanInput.csv" -checktype "$checktype""
        sshpass -p "$password" scp "$USERNAME"@"$server":~/Avanade-PortConnectivity-$checktype-$date/${server}*.CSV "$output_dir"
        :
        else
                echo -e "\nIncorrect checktype selected, checktype should be one of these options (Pre_Source/Pre_Target/Post)\n"
 fi
   echo -e "\n "
done < serverlist
