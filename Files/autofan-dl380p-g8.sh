#!/bin/bash
#
# crontab -l > mycron
# echo "#" >> mycron
# echo "# At every 2nd minute" >> mycron
# echo "*/1 * * * * /bin/bash /autofan.sh >> /tmp/cron.log" >> mycron
# crontab mycron
# rm mycron
# chmod +x /autofan.sh
#

PASSWORD="YOURILOPASSWORD"
USERNAME="YOURILOUSER"
ILOIP="YOURILOIP"

FILE="/usr/bin/sshpass"
echo "ESXI HP iLO Fan Control Utility - By Thomas Wilbur"
if [ -f "$FILE" ]; then
    echo "sshpass already loaded."
else 
esxcli network firewall ruleset set -e true -r httpClient
pwdlocation=$(pwd)
cd /tmp
wget https://raw.githubusercontent.com/thomaswilbur/HP-ILO-Fan-Control/main/Files/sshpass --no-check-certificate
mv sshpass /usr/bin/sshpass
chmod +x /usr/bin/sshpass
cd $pwdlocation
    echo "sshpass loaded."
fi

esxcli network firewall ruleset set -e true -r sshClient
#T1="$(sensors -Aj coretemp-isa-0000 | jq '.[][] | to_entries[] | select(.key | endswith("input")) | .value' | sort -rn | head -n1)"
#T2="$(sensors -Aj coretemp-isa-0001 | jq '.[][] | to_entries[] | select(.key | endswith("input")) | .value' | sort -rn | head -n1)"
sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP show /system1/sensor2 > /tmp/temp.txt
T1CLEAN=$(grep -Ihr "CurrentReading" /tmp/temp.txt)
T1=$(echo "${T1CLEAN/    CurrentReading=/}" | xargs)
T1=$(echo $T1 | sed 's/[^0-9]*//g')
rm -rf /tmp/temp.txt

sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP show /system1/sensor3 > /tmp/temp.txt
T2CLEAN=$(grep -Ihr "CurrentReading" /tmp/temp.txt)
T2=$(echo "${T2CLEAN/    CurrentReading=/}" | xargs)
T2=$(echo $T2 | sed 's/[^0-9]*//g')
rm -rf /tmp/temp.txt

sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP show /system1/sensor25 > /tmp/temp.txt
T2CLEAN=$(grep -Ihr "CurrentReading" /tmp/temp.txt)
RAID=$(echo "${T2CLEAN/    CurrentReading=/}" | xargs)
RAID=$(echo $RAID | sed 's/[^0-9]*//g')
rm -rf /tmp/temp.txt

sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 0 min 1'
sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 1 min 1'
sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 2 min 1'
sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 3 min 1'
sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 4 min 1'
sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 min 1'

echo "CPU 1 Temp $T1 C"


if [[ $T1 -gt 67 ]]
   then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 3 max 255'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 4 max 255'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 255'
elif [[ $T1 -gt 58 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 3 max 100'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 4 max 100'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 100'

elif [[ $T1 -gt 54 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 3 max 95'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 4 max 95'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 95'
elif [[ $T1 -gt 52 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 3 max 85'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 4 max 85'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 85'
elif [[ $T1 -gt 50 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 3 max 75'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 4 max 75'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 75'
else
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 3 max 70'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 4 max 70'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 70'
fi

echo "CPU 2 Temp $T2 C"

if [[ $T2 -gt 67 ]]
   then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 0 max 255'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 1 max 255'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 2 max 255'

elif [[ $T2 -gt 58 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 0 max 100'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 1 max 100'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 2 max 100'
elif [[ $T2 -gt 54 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 0 max 95'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 1 max 95'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 2 max 95'
elif [[ $T2 -gt 52 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 0 max 85'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 1 max 85'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 2 max 85'
elif [[ $T2 -gt 50 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 0 max 75'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 1 max 75'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 2 max 75'
else
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 0 max 70'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 1 max 70'
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 2 max 70'
fi

echo "RAID Temp $RAID C"
if [[ $RAID -gt 97 ]]
   then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 255'
elif [[ $RAID -gt 95 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 150'
elif [[ $RAID -gt 94 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 120'
elif [[ $RAID -gt 93 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 100'
elif [[ $RAID -gt 92 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 90'
elif [[ $RAID -gt 91 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 85'
elif [[ $RAID -gt 90 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 80'
elif [[ $RAID -gt 89 ]]
    then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 75'
else
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no -oKexAlgorithms=+diffie-hellman-group14-sha1 $USERNAME@$ILOIP 'fan p 5 max 70'
fi
