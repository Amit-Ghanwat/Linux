#!/bin/bash

bg_magenta='\033[0;44m'
clear='\033[0m'

#Accepts username from User to login on the target servers & stores in a variable.
echo -ne "Enter your Username:\n"
read username
USERNAME=$username

#Accepts password from user & stores in a variable..
echo -ne "Enter your Password:\n"
read -s pass
password=$pass

#Accepts Checktype from user & stores in a variable..
echo -ne "Enter the Checktype (Pre_Source/Pre_Target/Post):\n"
read CheckType
checktype=$CheckType

date=`date "+%d%b%Y"`

#Accepts the path of Portconnectivity script from user & stores in a variable.
echo -n -e "Enter path of the PortConnectivity script (${bg_magenta}To get the path use command- 'find ~ -name portconnectivity.py${clear}'):\n"
read path
local_script=$path

#Accepts the path of Output Directory from user & stores in a variable.
echo -n -e "Enter path of Output Directory (${bg_magenta}To get the path cd to your Output directory & use command 'pwd'${clear}):\n"
read op_path
output_dir=$op_path

#Copies portconnectivity.py & PortScanInput from current m/c to target m/c.
#Runs .py script on target m/c.
#Copies output files from target server to current m/c based on checktype.
while read server;
do
   echo -e "\n"
   echo -e "${bg_magenta}~~~~~~ Connecting to $server ~~~~~~${clear}"
   sshpass -p "$password" scp "$local_script" ""$server"_PortScanInput.csv" "$USERNAME"@"$server":~/
   sshpass -p "$password" ssh -n -tt -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$USERNAME"@"$server" "python ~/portconnectivity.py -inputfile "$server"_PortScanInput.csv -checktype "$checktype""
	
   if [[ $checktype == 'Pre_Source' ]];
		then
        	cd $output_dir
	        mkdir $server-$checktype-$date
		cd ..
	        sshpass -p "$password" scp "$USERNAME"@"$server":~/${server}_Pre_PortTest_Source.CSV "$output_dir/$server-$checktype-$date"
        elif [[ $checktype == 'Pre_Target' ]];
		then
        	cd $output_dir
	        mkdir $server-$checktype-$date
        	cd ..
		sshpass -p "$password" scp "$USERNAME"@"$server":~/${server}_Pre_PortTest_Target.CSV "$output_dir/$server-$checktype-$date"
	elif [[ $checktype == 'Post' ]];
		then
        	cd $output_dir
	        mkdir $server-$checktype-$date
        	cd ..
		sshpass -p "$password" scp "$USERNAME"@"$server":~/${server}_Post_PortTest_Target.CSV "$output_dir/$server-$checktype-$date"
	else
        	echo -e "\n Select correct checktype"	
		:
   fi	

   echo -e "\n "

done < serverlist


