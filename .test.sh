#!/bin/bash
read -p "Enter password:" pass
B="sudo -i <<'EOF'"`cat ./uninstall.sh``echo -e '\nEOF'`
while read ip;
do
   echo -e "\n"
   echo "~~~~~~ Connecting to $ip ~~~~~~"
   #sshpass -p 'password_here'
   #sshpass -e
   #gpg -d -q sshpasswd.gpg | sshpass
   ssh -n -tt -o ConnectTimeout=10 -o StrictHostKeyChecking=no admin2316@$ip "$B"
   $pass
   echo -e "\n "
done < serverlist
