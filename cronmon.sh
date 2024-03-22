#!/usr/bin/bash
# This script will monitor to see if crond is running and then echo to STDOUT if it is running
# If it stops running it will echo that it is not running to STDOUT once and then quit 

##### Define initial variable and then check if it is running
ISRUNNING=`systemctl status crond | grep running | awk '{ print $3 }' | cut -d \( -f 2 | cut -d \) -f 1 | head -1`

# Establish if cron is running or not
if [[ -n "$ISRUNNING" ]]; then
	echo "Cron is running"
else    echo "Cron is not running"
	exit;
fi

###### Here is the montoring loop #####
echo " "
echo "Entering into monitoring loop now"

while [[ "$ISRUNNING" == "running" ]]
do
ISRUNNING=`systemctl status crond | grep running | awk '{ print $3 }' | cut -d \( -f 2 | cut -d \) -f 1 | head -1`

if [ -n "$ISRUNNING" ]; then
		echo "`date`: Cron is running"
	else
		echo "`date`: Cron is not running notify the support team"
		exit
fi
sleep 2
done

# Final note to STDOUT and we are done
echo "Cron is not running - notify the support team"
