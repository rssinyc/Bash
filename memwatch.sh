#!/usr/bin/bash
# This is a basic memory monitoring script that takes the output of free -m
# It puts USED FREE and TOTAL RAM into variables via AWK
while true
do
    read USED FREE TOTAL <<< $(free -m | awk '/Mem:/ {print $3, $4, $2}')
    PERCENT_UTILIZED=$(awk "BEGIN {printf \"%.2f\", ($USED / $TOTAL) * 100}")
    echo "Used Memory is $USED MB"
    echo "Free Memory is $FREE MB"
    echo "Memory Utilization is ${PERCENT_UTILIZED}%"

# If total memory exceeds 75% it writes this to /var/log/messages

    if (( $(awk 'BEGIN {print ("'$PERCENT_UTILIZED'" > 75)}') )); then
        echo "$(date +"%Y-%m-%d %H:%M:%S") Memory utilization exceeds 75%" | sudo tee -a /var/log/messages >/dev/null
    fi
    
    sleep 2
done
