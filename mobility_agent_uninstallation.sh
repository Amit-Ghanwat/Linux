#!/bin/bash

echo -ne "Enter your Username:\n"
read username
USERNAME=$username
echo -ne "Enter your Password:\n"
read -s pass
password=$pass

B="sudo -i <<'EOF'"`cat ./uninstall.sh``echo -e '\nEOF'`
while read server;
do
   echo "~~~~~~ Connecting to $server ~~~~~~"
   sshpass -p $password ssh -n -tt -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$USERNAME"@"$server" "$B" ;
   echo -e "\n "
done < serverlist
