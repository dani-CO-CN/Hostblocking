#!/bin/bash

# Time to block Moday through Friday from 8:00-18:00
begin=$(date --date="8:00" +%s)
end=$(date --date="18:00" +%s)
now=$(date +%s)
day_of_week=$(date +%u)

hosts_to_block=("reddit.com" "orf.at" "facebook.com" "youtube.com" "ycombinator.com" "derstandard.at")

if [[ $UID != 0 ]]; then
    echo "This script requires elevated priveleges, run with sudo!"
    exit 1
fi

for i in "${hosts_to_block[@]}"
do
   if ! grep -q "$i" /etc/hosts
   then
        #echo "$i not found, add to file"
        echo "127.0.0.1 *$i www.$i" >> /etc/hosts  
    fi
done


if [ "$begin" -le "$now" -a "$now" -le "$end" -a "$day_of_week" -lt 6 ]  ## time to block
then
    #echo "block"
    sed -i "s/^#127.0.0.1/127.0.0.1/g" /etc/hosts
else
    #echo "unblock"
    sed -i "s/^127.0.0.1/#127.0.0.1/g" /etc/hosts
fi
